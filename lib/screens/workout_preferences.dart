import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'package:wellnash_4/services/auth_services.dart';

class WorkoutPreferences extends StatefulWidget {
  @override
  _WorkoutPreferencesState createState() => _WorkoutPreferencesState();
}

class _WorkoutPreferencesState extends State<WorkoutPreferences> {
  int _workoutDays = 3;
  String _workoutRegime = 'Option 1';
  final AuthService authService = AuthService();

  void _submitPreferences() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    authService.updateWorkoutPreferences(
      context: context,
      userId: userId,
      workoutDays: _workoutDays,
      workoutRegime: _workoutRegime,
    ).then((_) {
      // Navigate to the next page or home page after preferences are updated
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<int>(
              value: _workoutDays,
              decoration: const InputDecoration(labelText: 'Days per week'),
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
            DropdownButtonFormField<String>(
              value: _workoutRegime,
              decoration: const InputDecoration(labelText: 'Workout Regime'),
              items: ['Option 1', 'Option 2']
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPreferences,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
