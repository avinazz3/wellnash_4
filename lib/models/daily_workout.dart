import 'exercise.dart';

class DailyWorkout {
  final int id;
  final String title;
  final int week;
  final int day;
  final DateTime date;
  final List<Exercise> exercises;

  DailyWorkout({
    required this.id,
    required this.title,
    required this.week,
    required this.day,
    required this.date,
    required this.exercises,
  });
}