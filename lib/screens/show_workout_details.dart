import 'package:flutter/material.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/services/auth_services.dart';

class ShowWorkoutDetailsScreen extends StatelessWidget {
  final DailyWorkout dailyWorkout;

  const ShowWorkoutDetailsScreen({required this.dailyWorkout, super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Finish workout and save to workout log
            },
            child: const Text('Finish'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dailyWorkout.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Week ${dailyWorkout.week} • Day ${dailyWorkout.day}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            for (final exercise in dailyWorkout.exercises) ExerciseWidget(exercise: exercise),
          ],
        ),
      ),
    );
  }
}

class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const ExerciseWidget({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Main lift', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            for (final set in exercise.sets) SetWidget(set: set),
          ],
        ),
      ),
    );
  }
}

class SetWidget extends StatelessWidget {
  final ExerciseSet set;

  const SetWidget({required this.set});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('${set.intensity}%', style: const TextStyle(fontSize: 16))),
        Expanded(child: Text('${set.targetKg} kg x ${set.reps}', style: const TextStyle(fontSize: 16))),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(labelText: 'kg'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              set.actualKg = double.parse(value);
            },
          ),
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(labelText: 'reps'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              set.actualReps = int.parse(value);
            },
          ),
        ),
      ],
    );
  }
}

