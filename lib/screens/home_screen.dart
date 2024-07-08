import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellnash_4/models/user.dart';
import 'package:wellnash_4/screens/history_screen.dart';
import 'package:wellnash_4/services/auth_services.dart';
import 'package:wellnash_4/utils/custom_datetime_line.dart';
import 'package:wellnash_4/utils/muscle_highlighter.dart';
import 'profile_screen.dart';
import 'select_gym_screen.dart';
import 'package:wellnash_4/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncUserData();
    });
  }

  void _syncUserData() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final user = authService.supabase.auth.currentUser;
    userProvider.setUser(user as User);
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.02),
                        _buildWelcomeMessage(user, screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildCustomDateTimeline(screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildMuscleHighlighter(screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildTodaysWorkout(screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildStartWorkoutButton(context, screenSize),
                        SizedBox(height: screenSize.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

  Widget _buildWelcomeMessage(User? user, Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 251, 93, 2), Color.fromARGB(255, 239, 191, 2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        'Welcome, ${user?.name ?? 'Guest'}!',
        style: TextStyle(
          fontSize: screenSize.width * 0.06,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCustomDateTimeline(Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: CustomDateTimeline(
        onDateChange: (selectedDate) {
          // Handle date selection
        },
      ),
    );
  }

  Widget _buildMuscleHighlighter(Size screenSize) {
    return Container(
      height: screenSize.height * 0.4,
      width: screenSize.width * 0.9,
      padding: EdgeInsets.all(screenSize.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MuscleHighlighter(),
    );
  }

  Widget _buildTodaysWorkout(Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 236, 72, 2), Color.fromARGB(255, 233, 152, 2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Today's Workout",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            "Day 2: Legs",
            style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.045),
          ),
        ],
      ),
    );
  }

  Widget _buildStartWorkoutButton(BuildContext context, Size screenSize) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectGymScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.1,
          vertical: screenSize.height * 0.02,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        'Start Workout',
        style: TextStyle(fontSize: screenSize.width * 0.045, fontWeight: FontWeight.bold),
      ),
    );
  }
}