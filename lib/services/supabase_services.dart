import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/daily_workout_exercise.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/models/user.dart' as models;
import 'package:wellnash_4/models/workout_log.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/models/gym.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // User functions
  Future<User?> getUser(String userId) async {
    final response =
        await supabase.from('users').select().eq('id', userId).single();
    return response != null ? User.fromJson(response) : null;
  }

  Future<void> updateUser(models.User user) async {
    await supabase.from('users').upsert({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'profile_picture_url': user.profilePictureUrl,
      'goals': user.goals,
      'workout_days': user.workoutDays,
      'workout_regime': user.workoutRegime,
      'current_workout_plan': user.currentWorkoutPlan,
      'height': user.height,
      'weight': user.weight,
      'activity_level': user.activityLevel,
      'profile_completed': user.profileCompleted,
    });
  }

  // Workout Log functions
  Future<WorkoutLog?> getWorkoutLog(String userId) async {
    final response = await supabase
        .from('workout_logs')
        .select()
        .eq('user_id', userId)
        .single();
    return response != null ? WorkoutLog.fromJson(response) : null;
  }

  Future<void> createWorkoutLog(String userId) async {
    try {
      await supabase.from('workout_logs').insert({
        'user_id': userId,
      });
      print('Workout log created');
    } catch (e) {
      print('Error creating workout log: $e');
      rethrow;
    }
  }

  // Daily Workout functions
  Future<List<DailyWorkout>> getDailyWorkouts(String workoutLogId) async {
    final response = await supabase
        .from('dailyworkouts')
        .select()
        .eq('workout_log_id', workoutLogId)
        .order('date', ascending: false);
    return (response as List)
        .map((workout) => DailyWorkout.fromJson(workout))
        .toList();
  }

  Future<void> createDailyWorkout(DailyWorkout workout) async {
    await supabase.from('dailyworkouts').insert({
      'workout_log_id': workout.workoutLogId,
      'name': workout.name,
      'date': workout.date.toIso8601String(),
      'workout_regime': workout.workoutRegime,
      'time_started': workout.timeStarted.toIso8601String(),
      'time_ended': workout.timeEnded?.toIso8601String(),
      'duration': workout.duration?.inMicroseconds,
    });
  }

  // Daily Workout Exercise functions
  Future<List<DailyWorkoutExercise>> getDailyWorkoutExercises(
      String dailyWorkoutId) async {
    final response = await supabase
        .from('dailyworkout_exercises')
        .select()
        .eq('dailyworkout_id', dailyWorkoutId)
        .order('exercise_order');
    return (response as List)
        .map((exercise) => DailyWorkoutExercise.fromJson(exercise))
        .toList();
  }

  Future<void> createDailyWorkoutExercise(DailyWorkoutExercise exercise) async {
    await supabase.from('dailyworkout_exercises').insert({
      'dailyworkout_id': exercise.dailyWorkoutId,
      'exercise_id': exercise.exerciseId,
      'exercise_order': exercise.exerciseOrder,
      'target_weight': exercise.targetWeight,
      'actual_weight': exercise.actualWeight,
      'sets': exercise.sets,
      'reps': exercise.reps,
    });
  }

  // Gym functions
  Future<List<Gym>> getGyms() async {
    final response = await supabase.from('gyms').select();
    return (response as List).map((gym) => Gym.fromJson(gym)).toList();
  }

  Future<void> addUserGym(String userId, String gymId) async {
    await supabase.from('user_gyms').insert({
      'user_id': userId,
      'gym_id': gymId,
    });
  }

  Future<DailyWorkout> getDailyWorkoutWithExercises(
      String dailyWorkoutId) async {
    final dailyWorkoutResponse = await supabase
        .from('dailyworkouts')
        .select()
        .eq('id', dailyWorkoutId)
        .single();

    final dailyWorkout = DailyWorkout.fromJson(dailyWorkoutResponse);

    final exercisesResponse =
        await supabase.from('dailyworkout_exercises').select('''
        *,
        exercise:exercises(*),
        exercise_sets(*)
      ''').eq('dailyworkout_id', dailyWorkoutId).order('exercise_order');

    dailyWorkout.exercises = await Future.wait(exercisesResponse.map((e) async {
      final exerciseJson = e['exercise'] as Map<String, dynamic>;
      final exerciseSets = e['exercise_sets'] as List<dynamic>;

      return Exercise(
        id: exerciseJson['id'],
        name: exerciseJson['name'],
        category: exerciseJson['category'],
        description: exerciseJson['description'],
        order: e['exercise_order'],
        sets: exerciseSets
            .map((set) => ExerciseSet(
                  id: set['id'],
                  setNumber: set['set_number'],
                  intensity: set['intensity'] ?? 0,
                  targetWeight: set['target_weight']?.toDouble() ?? 0.0,
                  targetReps: set['target_reps'] ?? 0,
                  actualWeight: set['actual_weight']?.toDouble(),
                  actualReps: set['actual_reps'],
                ))
            .toList(),
      );
    }));

    return dailyWorkout;
  }

  Future<void> addSet(String exerciseId, String dailyWorkoutId, ExerciseSet newSet) async {
    try {
      // First, fetch the dailyworkout_exercise_id
      final dailyWorkoutExerciseResponse = await supabase
          .from('dailyworkout_exercises')
          .select('id')
          .eq('exercise_id', exerciseId)
          .eq('dailyworkout_id', dailyWorkoutId)
          .single();


      final dailyWorkoutExerciseId = dailyWorkoutExerciseResponse['id'];

      // Now insert the new set
      final response = await supabase.from('exercise_sets').insert({
        'dailyworkout_exercise_id': dailyWorkoutExerciseId,
        'set_number': newSet.setNumber,
        'target_weight': newSet.targetWeight,
        'target_reps': newSet.targetReps,
        'actual_weight': newSet.actualWeight,
        'actual_reps': newSet.actualReps,
      }).select();


      // Update the newSet with the generated ID
      newSet.id = response[0]['id'];
    } catch (e) {
      print('Error adding set: $e');
      rethrow;
    }
  }

  Future<void> deleteSet(String setId) async {
    await supabase.from('exercise_sets').delete().eq('id', setId);
  }

  Future<void> updateSet(String setId, double? actualWeight, int? actualReps) async {
    await supabase.from('exercise_sets').update({
      'actual_weight': actualWeight,
      'actual_reps': actualReps,
    }).eq('id', setId);
  }

 Future<void> addExercise(String dailyWorkoutId, Exercise newExercise) async {
  try {
    // Insert the new exercise
    final exerciseResponse = await supabase.from('exercises').insert({
      'name': newExercise.name,
      'description': newExercise.description,
      'category': newExercise.category,
    }).select().single();

    // Get the new exercise ID
    final exerciseId = exerciseResponse['id'];

    // Insert the dailyworkout_exercise relationship
    final dailyWorkoutExerciseResponse = await supabase.from('dailyworkout_exercises').insert({
      'dailyworkout_id': dailyWorkoutId,
      'exercise_id': exerciseId,
      'exercise_order': newExercise.order,
    }).select().single();

    // Get the dailyworkout_exercise ID
    final dailyWorkoutExerciseId = dailyWorkoutExerciseResponse['id'];

    // Add sets for the new exercise
    for (var set in newExercise.sets) {
      await addSet(exerciseId, dailyWorkoutId, set);
    }

    // Update the newExercise object with the generated ID
    newExercise.id = exerciseId;

  } catch (e) {
    print('Error adding exercise: $e');
    rethrow;
  }
}

  Future<void> deleteExercise(String exerciseId) async {
    // First, delete all sets associated with this exercise
    await supabase.from('exercise_sets').delete().eq('dailyworkout_exercise_id', exerciseId);
    
    // Then, delete the exercise itself
    await supabase.from('dailyworkout_exercises').delete().eq('id', exerciseId);
  }
}
