import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/services/supabase_services.dart';

class ExerciseWidget extends StatefulWidget {
  final Exercise exercise;
  final int exerciseNumber;
  final SupabaseService supabaseServices;
  final VoidCallback onExerciseUpdated;
  final Function(Exercise) onExerciseDeleted;
  final String dailyWorkoutId;

  const ExerciseWidget({
    required this.exercise,
    required this.exerciseNumber,
    required this.supabaseServices,
    required this.onExerciseUpdated,
    required this.onExerciseDeleted,
    required this.dailyWorkoutId, 
    Key? key,
  }) : super(key: key);

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {

  Future<void> _addSet() async {
  final newSetNumber = widget.exercise.sets.length + 1;
  final newSet = ExerciseSet(
    id: '',
    setNumber: newSetNumber,
    targetWeight: widget.exercise.sets.isNotEmpty 
        ? widget.exercise.sets.last.targetWeight 
        : 0, // Default to 0 if there are no existing sets
    targetReps: widget.exercise.sets.isNotEmpty 
        ? widget.exercise.sets.last.targetReps 
        : 0, // Default to 0 if there are no existing sets
  );

  try {
    await widget.supabaseServices.addSet(
      widget.exercise.id,
      widget.dailyWorkoutId, // Make sure this property is available in the widget
      newSet
    );
    setState(() {
      widget.exercise.sets.add(newSet);
    });
    widget.onExerciseUpdated();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add set: $e')),
    );
  }
}

  void _deleteSet(ExerciseSet set) async {
    await widget.supabaseServices.deleteSet(set.id);
    setState(() {
      widget.exercise.sets.remove(set);
    });
    widget.onExerciseUpdated();
  }

  void _updateSet(ExerciseSet set) async {
    await widget.supabaseServices
        .updateSet(set.id, set.actualWeight, set.actualReps);
    widget.onExerciseUpdated();
  }

  void _autofillSet(ExerciseSet set) {
    setState(() {
      set.actualWeight = set.targetWeight;
      set.actualReps = set.targetReps;
    });
    _updateSet(set);
  }

  void _autofillAllSets() {
    setState(() {
      for (var set in widget.exercise.sets) {
        set.actualWeight = set.targetWeight;
        set.actualReps = set.targetReps;
        _updateSet(set);
      }
    });
  }

  void _showRestTimer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int remainingSeconds = 60;
        return StatefulBuilder(
          builder: (context, setState) {
            Timer.periodic(const Duration(seconds: 1), (timer) {
              if (remainingSeconds > 0) {
                setState(() {
                  remainingSeconds--;
                });
              } else {
                timer.cancel();
                Navigator.of(context).pop();
              }
            });

            return AlertDialog(
              title: const Text('Rest Timer'),
              content: Text('$remainingSeconds seconds remaining'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Stop'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteExercise() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Exercise'),
          content: const Text('Are you sure you want to delete this exercise?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await widget.supabaseServices.deleteExercise(widget.exercise.id);
      widget.onExerciseDeleted(widget.exercise);
    }
  }

  void _swapExercise() {
    // This function will be implemented later
    // print('Swap exercise functionality to be implemented');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                '${widget.exerciseNumber} ${widget.exercise.name}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: _autofillAllSets,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String result) {
                  if (result == 'delete') {
                    _deleteExercise();
                  } else if (result == 'swap') {
                    _swapExercise();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete Exercise'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'swap',
                    child: Text('Swap Exercise'),
                  ),
                ],
              ),
            ]),
            Text(widget.exercise.category ?? 'No category',
                style: const TextStyle(fontSize: 16)),
            Text(widget.exercise.description ?? 'No description',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Text('Set', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Target',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('kg', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Reps', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                for (var set in widget.exercise.sets)
                  TableRow(
                    children: [
                      Text('${set.setNumber}'),
                      Text('${set.targetWeight} kg x ${set.targetReps}'),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                          ),
                          onChanged: (value) {
                            set.actualWeight = double.tryParse(value);
                            _updateSet(set);
                          },
                          controller: TextEditingController(
                              text: set.actualWeight?.toString() ?? ''),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                          ),
                          onChanged: (value) {
                            set.actualReps = int.tryParse(value);
                            _updateSet(set);
                          },
                          controller: TextEditingController(
                              text: set.actualReps?.toString() ?? ''),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () => _autofillSet(set),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteSet(set),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addSet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('+ Add Set'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
