import 'package:wellnash_4/models/exercise.dart';

class DailyWorkout {
  final String id;
  final String? workoutLogId; // Made nullable
  final String name;
  final DateTime date;
  final String workoutRegime;
  final DateTime timeStarted;
  final DateTime? timeEnded;
  final Duration? duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? week; // Made nullable
  final int? day; // Made nullable
  final String? userId; // Added userId field
  List<Exercise> exercises;

  DailyWorkout({
    required this.id,
    this.workoutLogId,
    required this.name,
    required this.date,
    required this.workoutRegime,
    required this.timeStarted,
    this.timeEnded,
    this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.week,
    this.day,
    this.userId,
    this.exercises = const [],
  });

  factory DailyWorkout.fromJson(Map<String, dynamic> json) {
    return DailyWorkout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      workoutRegime: json['workout_regime'],
      timeStarted: DateTime.parse(json['time_started']),
      timeEnded: json['time_ended'] != null
          ? DateTime.parse(json['time_ended'])
          : null,
      duration: _parseDuration(json['duration']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      week: json['week'],
      day: json['day'],
      exercises: (json['exercises'] as List<dynamic>?)?.map((exerciseData) {
            print('Parsing exercise: ${exerciseData['exercise']['name']}');
            final exerciseInfo = exerciseData['exercise'];
            final exerciseSets =
                (exerciseData['exercise_sets'] as List<dynamic>)
                    .map((setData) => ExerciseSet.fromJson(setData))
                    .toList();

            return Exercise(
              id: exerciseInfo['id'],
              name: exerciseInfo['name'],
              description: exerciseInfo['description'],
              category: exerciseInfo['category'],
              sets: exerciseSets, 
              order: exerciseInfo['exercise_order'],
            );
          }).toList() ??
          [],
    );
  }

  static Duration? _parseDuration(dynamic value) {
    if (value == null) return null;
    if (value is int) return Duration(microseconds: value);
    if (value is String) {
      final parts = value.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final secondsAndMilliseconds = parts[2].split('.');
        final seconds = int.parse(secondsAndMilliseconds[0]);
        final milliseconds = int.parse(secondsAndMilliseconds[1]);
        return Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
        );
      }
    }
    throw FormatException('Invalid duration format: $value');
  }
}
