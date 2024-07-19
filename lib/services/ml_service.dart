import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/models/exercise.dart';

class MLService {
  final supabase = Supabase.instance.client;

  Future<DailyWorkout> generateDailyWorkout(String userId, int duration) async {
    try {
      print('Starting generateDailyWorkout');

      // Check if the user is authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('User is not authenticated');
        throw Exception('User is not authenticated');
      }
      print('User is authenticated: ${user.id}');

      // Explicitly get the session and access token
      final session = supabase.auth.currentSession;
      if (session == null) {
        print('Session is null');
        throw Exception('Session is null');
      }
      if (session.accessToken == null) {
        print('Access token is null');
        throw Exception('Access token is null');
      }
      print('Access token is available');

      final accessToken = session.accessToken;
      // Print the first few characters of the token for debugging (don't log the entire token)
      print('Access token starts with: ${accessToken.substring(0, 10)}...');

      // Invoke the function with the access token
      print('Invoking Supabase function');
      final response = await supabase.functions.invoke(
        'generate-workout',
        body: {
          'userId': userId,
          'duration': duration,
        },
        headers: {
          'Authorization': 'Bearer $accessToken',
          'apikey':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4a3FzeXpzdWRpbXFycXJpZ3VrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk3OTkxNjgsImV4cCI6MjAzNTM3NTE2OH0.jmlbjYldvrSgW-gmJOg7fGvVLrK7bU1BYdP9k7o_yPk',
        },
      );

      print('Function response status: ${response.status}');
      print('Function response data: ${response.data}');

      if (response.status != 200) {
        final errorMessage = response.data['error'] ?? 'Unknown error';
        final errorStack = response.data['stack'] ?? 'No stack trace available';
        final errorDetails =
            response.data['details'] ?? 'No additional details';
        throw Exception(
            'Function error: $errorMessage\nStack: $errorStack\nDetails: $errorDetails');
      }

      final workoutId = response.data['workoutId'];
      if (workoutId == null) {
        throw Exception('Workout ID not returned from function');
      }

      return await getDailyWorkoutWithExercises(workoutId);
    } catch (e) {
      print('Error generating workout: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
      }
      rethrow;
    }
  }

  Future<DailyWorkout> getDailyWorkoutWithExercises(
      String dailyWorkoutId) async {
    try {
      final workoutData = await supabase.from('dailyworkouts').select('''
          *,
          dailyworkout_exercises (
            exercise_order,
            exercise:exercises (
              id,
              name,
              description,
              category
            ),
            exercise_sets (
              id,
              set_number,
              target_weight,
              target_reps,
              actual_weight,
              actual_reps
            )
          )
        ''').eq('id', dailyWorkoutId).single();

      return DailyWorkout(
        id: workoutData['id'],
        workoutLogId: workoutData['workout_log_id'],
        name: workoutData['name'] ?? 'Unnamed Workout',
        date: DateTime.parse(
            workoutData['date'] ?? DateTime.now().toIso8601String()),
        week: workoutData['week'] ?? 0,
        day: workoutData['day'] ?? 0,
        workoutRegime: workoutData['workout_regime'] ?? '',
        timeStarted: DateTime.parse(
            workoutData['time_started'] ?? DateTime.now().toIso8601String()),
        timeEnded: workoutData['time_ended'] != null
            ? DateTime.parse(workoutData['time_ended'])
            : null,
        duration: workoutData['duration'] != null
            ? Duration(seconds: workoutData['duration'])
            : null,
        createdAt: DateTime.parse(
            workoutData['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            workoutData['updated_at'] ?? DateTime.now().toIso8601String()),
        exercises: (workoutData['dailyworkout_exercises'] as List?)
                ?.map((exerciseData) => Exercise(
                      id: exerciseData['exercise']['id'],
                      name: exerciseData['exercise']['name'] ??
                          'Unnamed Exercise',
                      description: exerciseData['exercise']['description'],
                      category: exerciseData['exercise']['category'],
                      order: exerciseData['exercise_order'],
                      sets: (exerciseData['exercise_sets'] as List?)
                              ?.map((setData) => ExerciseSet(
                                    id: setData['id'],
                                    setNumber: setData['set_number'],
                                    targetWeight:
                                        (setData['target_weight'] as num?)
                                                ?.toDouble() ??
                                            0.0,
                                    targetReps:
                                        setData['target_reps'] as int? ?? 0,
                                    actualWeight:
                                        (setData['actual_weight'] as num?)
                                            ?.toDouble(),
                                    actualReps: setData['actual_reps'] as int?,
                                  ))
                              .toList() ??
                          [],
                    ))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error fetching daily workout: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
      }
      rethrow;
    }
  }

  Future<void> updateExerciseSet(
      String setId, double? actualWeight, int? actualReps) async {
    try {
      await supabase.from('exercise_sets').update({
        'actual_weight': actualWeight,
        'actual_reps': actualReps,
      }).eq('id', setId);
    } catch (e) {
      print('Error updating exercise set: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
      }
      rethrow;
    }
  }

  Future<void> finishWorkout(String dailyWorkoutId, Duration duration) async {
    try {
      await supabase.from('dailyworkouts').update({
        'time_ended': DateTime.now().toIso8601String(),
        'duration': duration.inSeconds,
      }).eq('id', dailyWorkoutId);
    } catch (e) {
      print('Error finishing workout: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
      }
      rethrow;
    }
  }
}
