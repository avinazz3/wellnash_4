import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/workout_details.dart';
import 'package:wellnash_4/services/ml_service.dart';
import 'package:wellnash_4/models/daily_workout.dart';

class GeneratingWorkoutScreen extends StatefulWidget {
  final int duration;
  final String userId; 

  const GeneratingWorkoutScreen(
      {required this.duration,
      required this.userId, 
      Key? key})
      : super(key: key);

  @override
  _GeneratingWorkoutScreenState createState() =>
      _GeneratingWorkoutScreenState();
}

class _GeneratingWorkoutScreenState extends State<GeneratingWorkoutScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    generateWorkout();
  }

  Future<void> generateWorkout() async {
    try {
      // Fetch additional user data from the database if needed
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', widget.userId)
          .single();

      // Use the fetched data along with the passed duration
      MLService mlService = MLService();
      DailyWorkout generatedWorkout = await mlService.generateDailyWorkout(
        widget.userId,
        widget.duration,
        // Add any additional fields you need
      );

      if (mounted) {
        // Navigate to workout details screen once the workout is generated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(
              dailyWorkout: generatedWorkout,
              userId: widget.userId, // Pass the user ID here
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate workout: $e')),
        );
        Navigator.pop(context); // Go back to previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Generating your workout',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
