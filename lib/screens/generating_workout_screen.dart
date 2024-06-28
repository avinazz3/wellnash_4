import 'package:flutter/material.dart';
import 'package:wellnash_4/screens/workout_details.dart';
import 'package:wellnash_4/services/ml_service.dart';
import 'package:wellnash_4/models/daily_workout.dart';


class GeneratingWorkoutScreen extends StatefulWidget {
  final int duration;

  const GeneratingWorkoutScreen({required this.duration, super.key});

  @override
  _GeneratingWorkoutScreenState createState() => _GeneratingWorkoutScreenState();
}

class _GeneratingWorkoutScreenState extends State<GeneratingWorkoutScreen> {
  @override
  void initState() {
    super.initState();
    generateWorkout();
  }

  void generateWorkout() async {
    // Simulate ML model call
    MLService mlService = MLService();
    DailyWorkout dailyWorkout = await mlService.generateDailyWorkout('userId'); // replace 'userId' with actual user ID

    // Navigate to workout details screen once the workout is generated
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailsScreen(dailyWorkout: dailyWorkout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
