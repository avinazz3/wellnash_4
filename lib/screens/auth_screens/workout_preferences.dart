import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'package:wellnash_4/services/auth_services.dart';

class WorkoutPreferences extends StatefulWidget {
  @override
  _WorkoutPreferencesState createState() => _WorkoutPreferencesState();
}

class _WorkoutPreferencesState extends State<WorkoutPreferences> {
  int _workoutDays = 3;
  String _workoutRegime = 'Upper Lower';
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _submitPreferences() async {
    final authService = Provider.of<AuthService>(context);
    final user = authService.supabase.auth.currentUser;
    final userId = user?.id;

    try {
       await supabase.from('users').update({
        'workoutDays': _workoutDays,
        'workoutRegime': _workoutRegime,
      }).eq('id', userId!).maybeSingle();

      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout preferences updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } 
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
