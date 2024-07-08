import 'package:flutter/material.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/screens/show_workout_details.dart';

class CondensedWorkoutWidget extends StatelessWidget {
  final DailyWorkout dailyWorkout;

  const CondensedWorkoutWidget({required this.dailyWorkout, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowWorkoutDetailsScreen(dailyWorkout: dailyWorkout),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dailyWorkout.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${dailyWorkout.date.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Week ${dailyWorkout.week} • Day ${dailyWorkout.day}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dailyWorkout.exercises.map((exercise) {
                  return Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 16),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
