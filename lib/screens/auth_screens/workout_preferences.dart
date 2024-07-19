import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/utils/utils.dart'; 

class WorkoutPreferences extends StatefulWidget {
  @override
  _WorkoutPreferencesState createState() => _WorkoutPreferencesState();
}

class _WorkoutPreferencesState extends State<WorkoutPreferences> {
  int _workoutDays = 3;
  String _workoutRegime = 'Upper Lower';
  final supabase = Supabase.instance.client;

  Future<void> _submitPreferences() async {
    final user = supabase.auth.currentUser;
    final userId = user?.id;

    if (userId == null) {
      if (mounted) {
        showErrorSnackBar(context, message: 'User not authenticated');
      }
      return;
    }

    try {
      await supabase.from('users').update({
        'workout_days': _workoutDays,
        'workout_regime': _workoutRegime,
      }).eq('id', userId);

      if (mounted) {
        showSnackBar(context, message: 'Workout preferences updated successfully');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        showErrorSnackBar(context, message: error.message);
      }
    } catch (error) {
      if (mounted) {
        showErrorSnackBar(context, message: 'Unexpected error occurred: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Preferences'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 187, 87), Color.fromARGB(255, 248, 247, 246)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color.fromARGB(255, 255, 187, 87),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField<int>(
                    value: _workoutDays,
                    decoration: InputDecoration(
                      labelText: 'Days per week',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [1, 2, 3, 4, 5, 6, 7]
                        .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value days'),
                          );
                        })
                        .toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _workoutDays = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color.fromARGB(255, 255, 187, 87),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField<String>(
                    value: _workoutRegime,
                    decoration: InputDecoration(
                      labelText: 'Workout Regime',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['Upper Lower', 'Push Pull Legs', 'Full Body', 'Bro Split']
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _workoutRegime = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 255, 91, 2), Color.fromARGB(255, 239, 211, 4)],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _submitPreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}