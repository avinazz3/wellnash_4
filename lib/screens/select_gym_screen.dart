import 'package:flutter/material.dart';
import 'select_duration_screen.dart'; 

class SelectGymScreen extends StatelessWidget {
  const SelectGymScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Gym'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectDurationScreen()),
                );
              },
              child: const Text('Utown Gym'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 80), 
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text(' + Add Gym'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40), 
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

