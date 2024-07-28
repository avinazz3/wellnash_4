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
      if (workoutId == null || workoutId.toString().isEmpty) {
        throw Exception('Invalid or missing workout ID returned from function');
      }

      print('Workout ID received: $workoutId');
      return await getDailyWorkoutWithExercises(workoutId.toString());
    } catch (e) {
      print('Error generating workout: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
      }
      rethrow;
    }
  }

  Future<DailyWorkout> getDailyWorkoutWithExercises(String dailyWorkoutId) async {
  try {
    print('Fetching daily workout with ID: $dailyWorkoutId');
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

    print('Workout data fetched: ${workoutData != null}');

    if (workoutData == null) {
      throw Exception('No workout data found for ID: $dailyWorkoutId');
    }

    String safeString(dynamic value) => value?.toString() ?? '';
    int safeInt(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
    double safeDouble(dynamic value) => double.tryParse(value?.toString() ?? '') ?? 0.0;
    DateTime safeDateTime(dynamic value) => 
        DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();

    return DailyWorkout(
      id: safeString(workoutData['id']),
      workoutLogId: safeString(workoutData['workout_log_id']),
      name: safeString(workoutData['name']),
      date: safeDateTime(workoutData['date']),
      week: safeInt(workoutData['week']),
      day: safeInt(workoutData['day']),
      workoutRegime: safeString(workoutData['workout_regime']),
      timeStarted: safeDateTime(workoutData['time_started']),
      timeEnded: workoutData['time_ended'] != null 
          ? safeDateTime(workoutData['time_ended']) 
          : null,
      duration: workoutData['duration'] != null
          ? Duration(seconds: safeInt(workoutData['duration']))
          : null,
      createdAt: safeDateTime(workoutData['created_at']),
      updatedAt: safeDateTime(workoutData['updated_at']),
      exercises: (workoutData['dailyworkout_exercises'] as List?)
              ?.map((exerciseData) {
                print('Processing exercise: ${exerciseData['exercise']['name']}');
                return Exercise(
                  id: safeString(exerciseData['exercise']['id']),
                  name: safeString(exerciseData['exercise']['name']),
                  description: safeString(exerciseData['exercise']['description']),
                  category: safeString(exerciseData['exercise']['category']),
                  order: safeInt(exerciseData['exercise_order']),
                  sets: (exerciseData['exercise_sets'] as List?)
                          ?.map((setData) {
                            print('Processing set: ${setData['set_number']}');
                            return ExerciseSet(
                              id: safeString(setData['id']),
                              setNumber: safeInt(setData['set_number']),
                              targetWeight: safeDouble(setData['target_weight']),
                              targetReps: safeInt(setData['target_reps']),
                              actualWeight: setData['actual_weight'] != null 
                                  ? safeDouble(setData['actual_weight']) 
                                  : null,
                              actualReps: setData['actual_reps'] != null 
                                  ? safeInt(setData['actual_reps']) 
                                  : null,
                            );
                          })
                          .toList() ??
                      [],
                );
              })
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
