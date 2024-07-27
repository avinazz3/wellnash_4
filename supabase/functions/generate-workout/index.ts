import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Anthropic from 'npm:@anthropic-ai/sdk'
import { config } from "https://deno.land/x/dotenv/mod.ts";

// Load the environment variables from the .env file
const env = config();

serve(async (req) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
  }

  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Only proceed with token verification and main logic for non-OPTIONS requests
    if (req.method !== 'OPTIONS') {
      const authHeader = req.headers.get('Authorization')
      if (!authHeader) {
        throw new Error('Missing authorization header')
      }

      // Create Supabase client
      const supabaseUrl = Deno.env.get('SUPABASE_URL')
      const supabaseServiceKey = Deno.env.get('SUPABASE_ANON_KEY')
      if (!supabaseUrl || !supabaseServiceKey) {
        throw new Error('Missing Supabase configuration')
      }
      const supabase = createClient(supabaseUrl, supabaseServiceKey, {
        auth: { persistSession: false }
      })

      // Verify the JWT token
      const { data: { user }, error: authError } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''))
      if (authError || !user) {
        throw new Error('Invalid authorization token')
      }

      // Parse request body
      const { userId, duration } = await req.json()
      if (userId !== user.id) {
        throw new Error('User ID mismatch')
      }

      // Fetch user data
      const { data: userData, error: userError } = await supabase
        .from('users')
        .select('goals, workout_regime')
        .eq('id', userId)
        .single()
      if (userError) throw userError

      // Create Anthropic client
      const anthropic = new Anthropic({
        apiKey: Deno.env.get('ANTHROPIC_API_KEY'),
      })

      // Fetch user's past workouts
      console.log('Fetching past workouts for user:', userId)
      let pastWorkouts
      try {
        const { data, error } = await supabase
          .from('dailyworkouts')
          .select(`
      id,
      date,
      dailyworkout_exercises (
        exercise_id,
        exercises (
          name,
          category
        ),
        exercise_sets (
          target_weight,
          target_reps,
          actual_weight,
          actual_reps
        )
      )
    `)
          .eq('user_id', userId)
          .order('date', { ascending: false })
          .limit(10)

        if (error) {
          console.error('Supabase error fetching past workouts:', error)
          throw error
        }

        if (!data) {
          console.warn('No data returned from past workouts query')
          pastWorkouts = []
        } else {
          pastWorkouts = data
          console.log(`Fetched ${pastWorkouts.length} past workouts`)
        }
      } catch (error) {
        console.error('Error fetching past workouts:', error)
        throw error
      }

      let workoutHistory = ''
      let bmiInfo = ''

      if (pastWorkouts && pastWorkouts.length > 0) {
        console.log('Processing past workouts')
        workoutHistory = `Past workouts:\n`
        pastWorkouts.forEach((workout, index) => {
          console.log(`Processing workout ${index + 1}:`, workout)
          workoutHistory += `Date: ${workout.date}\nExercises:\n`

          if (!workout.dailyworkout_exercises || workout.dailyworkout_exercises.length === 0) {
            console.warn(`No exercises found for workout on ${workout.date}`)
            workoutHistory += `  No exercises recorded\n`
          } else {
            workout.dailyworkout_exercises.forEach(exercise => {
              if (!exercise.exercises) {
                console.warn(`Missing exercise data for exercise_id: ${exercise.exercise_id}`)
                workoutHistory += `  Unknown exercise\n`
              } else {
                workoutHistory += `  Exercise: ${exercise.exercises.name || 'Unknown'} (${exercise.exercises.category || 'Unknown'})\n  Sets:\n`

                if (!exercise.exercise_sets || exercise.exercise_sets.length === 0) {
                  console.warn(`No sets found for exercise: ${exercise.exercises.name}`)
                  workoutHistory += `    No sets recorded\n`
                } else {
                  exercise.exercise_sets.forEach(set => {
                    workoutHistory += `    Target: ${set.target_weight || 'N/A'}kg x ${set.target_reps || 'N/A'} reps\n`
                    workoutHistory += `    Actual: ${set.actual_weight || 'N/A'}kg x ${set.actual_reps || 'N/A'} reps\n`
                  })
                }
              }
            })
          }
          workoutHistory += '\n'
        })
      } else {
        console.log('No past workouts found, fetching user metrics')
        // Fetch user's height and weight if no past workouts
        try {
          const { data: userMetrics, error: metricsError } = await supabase
            .from('users')
            .select('height, weight')
            .eq('id', userId)
            .single()

          if (metricsError) {
            console.error('Error fetching user metrics:', metricsError)
            throw metricsError
          }

          if (userMetrics && userMetrics.height && userMetrics.weight) {
            const heightInMeters = userMetrics.height / 100
            const bmi = userMetrics.weight / (heightInMeters * heightInMeters)
            bmiInfo = `User BMI: ${bmi.toFixed(2)} (Height: ${userMetrics.height}cm, Weight: ${userMetrics.weight}kg)`
            console.log('BMI info calculated:', bmiInfo)
          } else {
            console.warn('Incomplete user metrics:', userMetrics)
            bmiInfo = 'User metrics not available'
          }
        } catch (error) {
          console.error('Error in fetching user metrics:', error)
          bmiInfo = 'Error fetching user metrics'
        }
      }

      console.log('Workout history or BMI info prepared')

      // Fetch available exercises
      const { data: availableExercises, error: exercisesError } = await supabase
        .from('exercises')
        .select('name, category, description')

      if (exercisesError) throw exercisesError

      // Modify the prompt to include available exercises and past workouts or BMI
      const prompt = `
    Generate a workout plan based on the following user data:
    Goals: ${userData.goals}
    Current regime: ${userData.workout_regime}
    Requested duration: ${duration} minutes

    ${workoutHistory || bmiInfo}

    Available Exercises:
    ${availableExercises.map(exercise => `
      - ${exercise.name} (${exercise.category}): ${exercise.description}
    `).join('')}

    Important: Only use exercises from the provided list of available exercises.

    Provide the workout in the following JSON format:
    {
      "exercises": [
        {
          "name": "Exercise Name",
          "description": "Exercise Description - keep this very short!",
          "category": "Exercise Category (e.g., Main lift, Accessory)",
          "sets": [
            {
              "setNumber": 1,
              "targetWeight": 100,
              "targetReps": 8
            }
          ]
        }
      ]
    }

    Based on the user's history or BMI, adjust the target weights and reps appropriately.
    If using BMI, suggest appropriate starting weights for a beginner.
  `

      // Generate workout
      const message = await anthropic.messages.create({
        model: "claude-3-sonnet-20240229",
        max_tokens: 1024,
        messages: [{ role: "user", content: prompt }],
      })
      // Extract JSON from the content
      const content = message.content[0].text
      const jsonMatch = content.match(/\{[\s\S]*\}/)
      if (!jsonMatch) throw new Error('Failed to parse workout JSON from Claude response')

      const workoutPlan = JSON.parse(jsonMatch[0])

      // Create new daily workout
      const { data: dailyWorkout, error: dailyWorkoutError } = await supabase
        .from('dailyworkouts')
        .insert({
          user_id: userId,  // Changed from workout_log_id to user_id
          name: `Workout ${new Date().toISOString().split('T')[0]}`,
          date: new Date().toISOString(),
          workout_regime: userData.workout_regime,
          time_started: new Date().toISOString(),
        })
        .select()
        .single()
      if (dailyWorkoutError) throw dailyWorkoutError

      // Insert exercises and sets
      for (let i = 0; i < workoutPlan.exercises.length; i++) {
        const exercise = workoutPlan.exercises[i];

        // Insert or fetch exercise
        let { data: existingExercise, error: exerciseFetchError } = await supabase
          .from('exercises')
          .select('id')
          .eq('name', exercise.name)
          .single();

        if (exerciseFetchError && exerciseFetchError.code !== 'PGRST116') {
          throw exerciseFetchError;
        }

        if (!existingExercise) {
          const { data: newExercise, error: exerciseInsertError } = await supabase
            .from('exercises')
            .insert({
              name: exercise.name,
              description: exercise.description,
              category: exercise.category
            })
            .select()
            .single();

          if (exerciseInsertError) throw exerciseInsertError;
          existingExercise = newExercise;
        }

        // Insert relationship in dailyworkout_exercises
        const { data: dailyworkoutExercise, error: relationError } = await supabase
          .from('dailyworkout_exercises')
          .insert({
            dailyworkout_id: dailyWorkout.id,
            exercise_id: existingExercise.id,
            exercise_order: i + 1
          })
          .select()
          .single();

        if (relationError) throw relationError;

        // Insert sets
        for (const set of exercise.sets) {
          const { error: setError } = await supabase
            .from('exercise_sets')
            .insert({
              dailyworkout_exercise_id: dailyworkoutExercise.id,
              set_number: set.setNumber,
              target_weight: set.targetWeight,
              target_reps: set.targetReps
            });

          if (setError) throw setError;
        }
      }

      return new Response(
        JSON.stringify({ workoutId: dailyWorkout.id }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }
  } catch (error) {
    console.error('Error in Supabase function:', error)
    let errorMessage = 'An unexpected error occurred'
    let errorDetails = null

    if (error instanceof Error) {
      errorMessage = error.message
      errorDetails = error.stack
    }

    return new Response(
      JSON.stringify({
        error: errorMessage,
        details: errorDetails,
        type: error.constructor.name
      }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})