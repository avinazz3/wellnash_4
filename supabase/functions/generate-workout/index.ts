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
      const supabaseUrl = env.get('SUPABASE_URL')
      const supabaseServiceKey = env.get('SUPABASE_ANON_KEY')
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
        apiKey: env.get('ANTHROPIC_API_KEY'),
      })

      const prompt = `
        Generate a workout plan based on the following user data:
        Goals: ${userData.goals}
        Current regime: ${userData.workout_regime}
        Requested duration: ${duration} minutes

        Provide the workout in the following JSON format:
        {
          "exercises": [
            {
              "name": "Exercise Name",
              "description": "Exercise Description",
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

      // Get or create workout log
      let { data: workoutLog, error: workoutLogError } = await supabase
        .from('workout_logs')
        .select('id')
        .eq('user_id', userId)
        .single()

      if (workoutLogError) {
        const { data: newWorkoutLog, error: newWorkoutLogError } = await supabase
          .from('workout_logs')
          .insert({ user_id: userId })
          .select()
          .single()
        if (newWorkoutLogError) throw newWorkoutLogError
        workoutLog = newWorkoutLog
      }

      // Create new daily workout
      const { data: dailyWorkout, error: dailyWorkoutError } = await supabase
        .from('dailyworkouts')
        .insert({
          workout_log_id: workoutLog.id,
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