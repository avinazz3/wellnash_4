import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/models/exercise.dart';

class ShowWorkoutDetailsScreen extends StatefulWidget {
  final DailyWorkout dailyWorkout;
  final String userId;

  const ShowWorkoutDetailsScreen({
    required this.dailyWorkout,
    required this.userId,
    Key? key
  }) : super(key: key);

  @override
  _ShowWorkoutDetailsScreenState createState() => _ShowWorkoutDetailsScreenState();
}

class _ShowWorkoutDetailsScreenState extends State<ShowWorkoutDetailsScreen> {
  final supabase = Supabase.instance.client;

  Future<void> _finishWorkout() async {
    try {
      // Save the workout log to Supabase
      await supabase.from('workout_logs').insert({
        'user_id': widget.userId,
        'workout_id': widget.dailyWorkout.id,
        'completed_at': DateTime.now().toIso8601String(),
        // Add any other relevant data
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout completed and logged successfully!')),
        );
        Navigator.pop(context);  // Go back to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log workout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          ElevatedButton(
            onPressed: _finishWorkout,
            child: const Text('Finish'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.dailyWorkout.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Week ${widget.dailyWorkout.week} • Day ${widget.dailyWorkout.day}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              for (final exercise in widget.dailyWorkout.exercises) ExerciseWidget(exercise: exercise),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const ExerciseWidget({required this.exercise, Key? key}) : super(key: key);

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
            Text(exercise.category ?? 'No category', style: const TextStyle(fontSize: 16)),
            if (exercise.description != null)
              Text(exercise.description!, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
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

  const SetWidget({required this.set, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text('Set ${set.setNumber}', style: const TextStyle(fontSize: 16))),
          Expanded(child: Text('${set.intensity}%', style: const TextStyle(fontSize: 16))),
          Expanded(child: Text('${set.targetWeight} kg x ${set.targetReps}', style: const TextStyle(fontSize: 16))),
          if (set.actualWeight != null)
            Expanded(child: Text('${set.actualWeight} kg', style: const TextStyle(fontSize: 16, color: Colors.green))),
          if (set.actualReps != null)
            Expanded(child: Text('${set.actualReps} reps', style: const TextStyle(fontSize: 16, color: Colors.green))),
        ],
      ),
    );
  }
}