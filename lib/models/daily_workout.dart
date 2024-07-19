import 'package:wellnash_4/models/exercise.dart';

class DailyWorkout {
  final String id;
  final String workoutLogId;
  final String name;
  final DateTime date;
  final String workoutRegime;
  final DateTime timeStarted;
  final DateTime? timeEnded;
  final Duration? duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int week;
  final int day;
  List<Exercise> exercises;

  DailyWorkout({
    required this.id,
    required this.workoutLogId,
    required this.name,
    required this.date,
    required this.workoutRegime,
    required this.timeStarted,
    this.timeEnded,
    this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.week,
    required this.day,
    this.exercises = const [],
  });

  factory DailyWorkout.fromJson(Map<String, dynamic> json) {
    return DailyWorkout(
      id: json['id'],
      workoutLogId: json['workout_log_id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      week: json['week'],
      day: json['day'],
      workoutRegime: json['workout_regime'],
      timeStarted: DateTime.parse(json['time_started']),
      timeEnded: json['time_ended'] != null ? DateTime.parse(json['time_ended']) : null,
      duration: json['duration'] != null ? Duration(microseconds: json['duration']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // Note: exercises would typically be loaded separately or through a join
    );
  }
}