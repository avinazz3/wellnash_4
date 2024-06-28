import 'package:flutter/material.dart';
import 'package:wellnash_4/services/ml_service.dart';
import 'generating_workout_screen.dart';
import 'package:wellnash_4/screens/workout_details.dart';

class SelectDurationScreen extends StatelessWidget {
  const SelectDurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> durations = List.generate(33, (index) => 20 + index * 5);
    int selectedDuration = durations[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Duration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200, // Adjust height as needed
                  width: 100, // Adjust width as needed
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      selectedDuration = durations[index];
                    },
                    children: durations.map((duration) {
                      return Center(
                        child: Text(
                          '$duration',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Text(
                  ' mins',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneratingWorkoutScreen(
                      duration: selectedDuration,
                    ),
                  ),
                );
              },
              child: const Text('Generate'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50), // Width of the button
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
