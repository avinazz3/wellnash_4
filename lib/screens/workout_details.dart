import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/services/supabase_services.dart';
import 'package:wellnash_4/utils/exercise_widget.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final DailyWorkout dailyWorkout;
  final String userId;

  const WorkoutDetailsScreen({
    required this.dailyWorkout,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _WorkoutDetailsScreenState createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  final supabase = Supabase.instance.client;
  final SupabaseService _supabaseServices = SupabaseService();
  late Timer _timer;
  Duration _duration = Duration.zero;
  int _restTimerDuration = 60; // Default rest timer duration in seconds
  Timer? _restTimer;
  int _remainingRestTime = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showRestTimerSelector() {
    int minutes = _restTimerDuration ~/ 60;
    int seconds = _restTimerDuration % 60;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int value) {
                          minutes = value;
                        },
                        children: List<Widget>.generate(11, (int index) {
                          return Center(child: Text('$index'));
                        }),
                      ),
                    ),
                    const Text('min'),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int value) {
                          seconds = value;
                        },
                        children: List<Widget>.generate(60, (int index) {
                          return Center(child: Text('$index'));
                        }),
                      ),
                    ),
                    const Text('sec'),
                  ],
                ),
              ),
              CupertinoButton(
                child: const Text('Set'),
                onPressed: () {
                  setState(() {
                    _restTimerDuration = minutes * 60 + seconds;
                  });
                  Navigator.of(context).pop();
                  _startRestTimer();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startRestTimer() {
    setState(() {
      _remainingRestTime = _restTimerDuration;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingRestTime > 0) {
          _remainingRestTime--;
        } else {
          _restTimer?.cancel();
        }
      });
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _remainingRestTime = 0;
    });
  }

  Future<void> _finishWorkout() async {
    print('Starting _finishWorkout method');
    
    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finish Workout'),
          content: const Text('Are you sure you want to finish this workout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    print('Confirmation dialog result: $confirm');

    if (confirm == true) {
      print('Workout confirmed to finish');
      _timer.cancel();
      
      // Update the database
      final now = DateTime.now();
      try {
        await supabase.from('dailyworkouts').update({
          'time_ended': now.toIso8601String(),
        }).eq('id', widget.dailyWorkout.id);

        print('Database updated successfully');

        // Check if the widget is still mounted before proceeding
        if (!mounted) {
          print('Widget is not mounted after database update');
          return;
        }

        // Use a try-catch block for showing the dialog
        bool dialogShown = false;
        try {
          print('Attempting to show congratulations dialog');
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Congratulations!'),
                content: const Text('You have finished your workout for today!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          dialogShown = true;
          print('Congratulations dialog shown successfully');
        } catch (e) {
          print('Error showing congratulations dialog: $e');
        }

        // If dialog was shown, wait for 2 seconds, otherwise proceed immediately
        if (dialogShown) {
          await Future.delayed(const Duration(seconds: 2));
        }

        // Check if the widget is still mounted before proceeding
        if (!mounted) {
          print('Widget is not mounted after delay');
          return;
        }
      
        print('Attempting to navigate to HomeScreen');
        // Use a try-catch block for navigation
        try {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          print('Navigation to HomeScreen initiated');
        } catch (e) {
          print('Error navigating to HomeScreen: $e');
          // Attempt to use a different navigation method
          try {
            print('Attempting alternative navigation method');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
            print('Alternative navigation method initiated');
          } catch (e) {
            print('Error with alternative navigation method: $e');
          }
        }
      } catch (e) {
        print('Error finishing workout: $e');
        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error finishing workout: $e')),
          );
        } else {
          print('Widget is not mounted, cannot show error snackbar');
        }
      }
    } else {
      print('Workout finish cancelled');
    }
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

  void _addExercise() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String description = '';
        String category = '';
        double targetWeight = 0;
        int targetReps = 0;
        int numberOfSets = 1;

        return AlertDialog(
          title: const Text('Add Exercise'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Exercise Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) => description = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) => category = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Target Weight (kg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => targetWeight = double.tryParse(value) ?? 0,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Target Reps'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => targetReps = int.tryParse(value) ?? 0,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Number of Sets'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => numberOfSets = int.tryParse(value) ?? 1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                final newExercise = Exercise(
                  id: '', // Will be set by the database
                  name: name,
                  description: description,
                  category: category,
                  order: widget.dailyWorkout.exercises.length + 1,
                  sets: List.generate(
                    numberOfSets,
                    (index) => ExerciseSet(
                      id: '',
                      setNumber: index + 1,
                      targetWeight: targetWeight,
                      targetReps: targetReps,
                    ),
                  ),
                );

                await _supabaseServices.addExercise(widget.dailyWorkout.id, newExercise);
                setState(() {
                  widget.dailyWorkout.exercises.add(newExercise);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleExerciseDeleted(Exercise deletedExercise) {
    setState(() {
      widget.dailyWorkout.exercises.remove(deletedExercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dailyWorkout.name),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('Finish', style: TextStyle(color: Color.fromARGB(255, 241, 215, 190))),
          ),
        ],
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
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _remainingRestTime > 0 ? _stopRestTimer : _showRestTimerSelector,
                  child: Text(_remainingRestTime > 0
                      ? '${_remainingRestTime ~/ 60}:${(_remainingRestTime % 60).toString().padLeft(2, '0')}'
                      : 'Rest Timer'),
                ),
                Text(
                  'Week ${widget.dailyWorkout.week} • Day ${widget.dailyWorkout.day}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.dailyWorkout.exercises.length + 1,
              itemBuilder: (context, index) {
                if (index < widget.dailyWorkout.exercises.length) {
                  return ExerciseWidget(
                    dailyWorkoutId: widget.dailyWorkout.id,
                    exercise: widget.dailyWorkout.exercises[index],
                    exerciseNumber: index + 1,
                    supabaseServices: _supabaseServices,
                    onExerciseUpdated: () => setState(() {}),
                    onExerciseDeleted: _handleExerciseDeleted,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _addExercise,
                      child: const Text('+ Add Exercise'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}