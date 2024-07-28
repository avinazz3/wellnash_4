import 'package:flutter/material.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/models/exercise.dart';

class ShowWorkoutDetailsScreen extends StatelessWidget {
  final DailyWorkout dailyWorkout;

  const ShowWorkoutDetailsScreen({
    required this.dailyWorkout,
    Key? key,
  }) : super(key: key);

  String _formatDuration(Duration? duration) {
    if (duration == null) return 'N/A';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    print('Building ShowWorkoutDetailsScreen for ${dailyWorkout.name}');
    print('Number of exercises: ${dailyWorkout.exercises.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text(dailyWorkout.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(dailyWorkout.duration),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  'Week ${dailyWorkout.week} • Day ${dailyWorkout.day}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${dailyWorkout.date.toLocal().toString().split(' ')[0]}'),
                Text('Started: ${dailyWorkout.timeStarted.toLocal().toString()}'),
                if (dailyWorkout.timeEnded != null)
                  Text('Ended: ${dailyWorkout.timeEnded!.toLocal().toString()}'),
                Text('Regime: ${dailyWorkout.workoutRegime}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: dailyWorkout.exercises.length,
              itemBuilder: (context, index) {
                return ExerciseWidget(
                  exercise: dailyWorkout.exercises[index],
                  exerciseNumber: index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  final int exerciseNumber;

  const ExerciseWidget({
    required this.exercise,
    required this.exerciseNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building ExerciseWidget for ${exercise.name}');
    print('Number of sets: ${exercise.sets.length}');
    
    // Sort sets by set number
    final sortedSets = List<ExerciseSet>.from(exercise.sets)
      ..sort((a, b) => a.setNumber.compareTo(b.setNumber));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercise $exerciseNumber: ${exercise.name}', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (exercise.category != null) Text('Category: ${exercise.category}'),
            if (exercise.description != null) Text('Description: ${exercise.description}'),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    TableCell(child: Center(child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Center(child: Text('Target', style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Center(child: Text('Actual', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
                ...sortedSets.map((set) => TableRow(
                  children: [
                    TableCell(child: Center(child: Text(set.setNumber.toString()))),
                    TableCell(child: Center(child: Text('${set.targetWeight ?? 0} x ${set.targetReps ?? 0}'))),
                    TableCell(child: Center(child: Text(
                      set.actualWeight != null && set.actualReps != null
                        ? '${set.actualWeight} kg x ${set.actualReps}'
                        : 'N/A',
                      style: const TextStyle(color: Colors.green),
                    ))),
                  ],
                )).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}