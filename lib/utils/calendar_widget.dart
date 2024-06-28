import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (index) => today.subtract(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Last 7 Days',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((day) {
              bool hasWorkout = false; // Replace this with actual workout check

              return GestureDetector(
                onTap: hasWorkout
                    // ignore: dead_code
                    ? () {
                        // Navigate to the history page for the specific workout
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Text('History Page')), // Replace with actual HistoryPage
                        );
                      }
                    : null,
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // ignore: dead_code
                    color: hasWorkout ? Color.fromARGB(255, 60, 189, 64) : Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('d MMM').format(day),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
