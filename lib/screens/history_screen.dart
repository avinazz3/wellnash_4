import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/exercise.dart';
import 'package:wellnash_4/models/daily_workout.dart';
import 'package:wellnash_4/screens/show_workout_details.dart';
import 'package:wellnash_4/utils/condensed_workout_widget.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;
  DateTime? selectedDate;
  List<DailyWorkout> workoutLogs = [];
  bool _isLoading = true;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadWorkoutLogs();
  }

  Future<void> _loadWorkoutLogs() async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId != null) {
        print('Fetching workouts for user: $userId');

        final dailyWorkoutsResponse = await supabase
            .from('dailyworkouts')
            .select()
            .eq('user_id', userId)
            .order('date', ascending: false);

        //print('Raw response: $dailyWorkoutsResponse');

        if (dailyWorkoutsResponse is List) {
          setState(() {
            workoutLogs = dailyWorkoutsResponse
                .map((log) => DailyWorkout.fromJson(log))
                .toList();
            _isLoading = false;
          });
          print('Parsed ${workoutLogs.length} workouts');
        } else {
          print(
              'Unexpected response type: ${dailyWorkoutsResponse.runtimeType}');
          setState(() {
            workoutLogs = [];
            _isLoading = false;
          });
        }
      } else {
        print('No user logged in');
        setState(() {
          workoutLogs = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading workout logs: $e');
      setState(() {
        workoutLogs = [];
        _isLoading = false;
      });
    }
  }

  Future<DailyWorkout?> _getFullWorkoutDetails(String workoutId) async {
  try {
    final workoutData = await supabase
        .from('dailyworkouts')
        .select('''
          *,
          exercises:dailyworkout_exercises (
            id,
            exercise:exercises (
              id,
              name,
              description,
              category
            ),
            exercise_sets (*)
          )
        ''')
        .eq('id', workoutId)
        .single();

    return DailyWorkout.fromJson(workoutData);
  } catch (e) {
    print('Error fetching full workout details: $e');
    return null;
  }
}

  void _onWorkoutTapped(DailyWorkout workout) async {
    final fullWorkout = await _getFullWorkoutDetails(workout.id);
    if (fullWorkout != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowWorkoutDetailsScreen(
            dailyWorkout: fullWorkout,
            //userId: supabase.auth.currentUser!.id,
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load workout details')),
      );
    }
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
    return workoutLogs
        .where((log) =>
            log.date.year == selectedDate!.year &&
            log.date.month == selectedDate!.month &&
            log.date.day == selectedDate!.day)
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        // Do nothing, we're already on the History screen
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DailyWorkout> filteredLogs = _filteredWorkoutLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return GestureDetector(
                        onTap: () => _onWorkoutTapped(log),
                        child: CondensedWorkoutWidget(dailyWorkout: log),
                      );
                    },
                  ),
                ],
              ),
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
