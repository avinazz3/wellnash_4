import 'package:flutter/material.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/services/auth_services.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'show_workout_details.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/utils/condensed_workout_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;
  DateTime? selectedDate;
  List<DailyWorkout> workoutLogs = []; // Replace this with your workout log list

  @override
  void initState() {
    super.initState();
    // Load workout logs here. This is just a placeholder.
    workoutLogs = [
      DailyWorkout(
        id: 1,
        date: DateTime(2024, 5, 24),
        title: 'Upper Day 1',
        week: 1,
        day: 3,
        exercises: [
          Exercise(name: 'Deadlift (Barbell)', sets: [ExerciseSet(intensity: 65, targetKg: 16, reps: 12)]),
          Exercise(name: 'Leg Curl', sets: [ExerciseSet(intensity: 65, targetKg: 50, reps: 15)]),
          Exercise(name: 'Leg Extension', sets: [ExerciseSet(intensity: 65, targetKg: 35, reps: 12)]),
        ],
      ),
      DailyWorkout(
        id: 2,
        date: DateTime(2024, 5, 23),
        title: 'Upper Day 1',
        week: 1,
        day: 2,
        exercises: [
          Exercise(name: 'Bench Press (Barbell)', sets: [ExerciseSet(intensity: 65, targetKg: 60, reps: 6)]),
          Exercise(name: 'Tempo Overhead Press', sets: [ExerciseSet(intensity: 65, targetKg: 30, reps: 12)]),
          Exercise(name: 'Tricep Extension (Cable)', sets: [ExerciseSet(intensity: 65, targetKg: 21, reps: 15)]),
          Exercise(name: 'Bicep Curl (Dumbbell)', sets: [ExerciseSet(intensity: 65, targetKg: 10, reps: 12)]),
          Exercise(name: 'Rear Delt Fly (Dumbbell)', sets: [ExerciseSet(intensity: 65, targetKg: 32.5, reps: 12)]),
          Exercise(name: 'Wide Grip Pull-Up', sets: [ExerciseSet(intensity: 65, targetKg: 0, reps: 12)]),
        ],
      ),
    ];
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _clearFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  List<DailyWorkout> _filteredWorkoutLogs() {
    if (selectedDate == null) return workoutLogs;
    return workoutLogs.where((log) => log.date == selectedDate).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DailyWorkout> filteredLogs = _filteredWorkoutLogs();
    final authService = Provider.of<AuthService>(context);
    final user = authService.supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateChanged: _onDateSelected,
          ),
          if (selectedDate != null)
            TextButton(
              onPressed: _clearFilter,
              child: const Text('Clear'),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return CondensedWorkoutWidget(dailyWorkout: log);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
