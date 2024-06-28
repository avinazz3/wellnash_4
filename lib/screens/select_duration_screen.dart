import 'package:flutter/material.dart';

class SelectDurationScreen extends StatelessWidget {
  const SelectDurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> durations = List.generate(33, (index) => 20 + index * 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Duration'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200, // Adjust height as needed
              width: 100, // Adjust width as needed
              child: ListWheelScrollView(
                itemExtent: 50,
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
      ),
    );
  }
}
