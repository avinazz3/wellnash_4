import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'login_screen.dart';
import 'getting_user_details.dart';


class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  Widget? _nextScreen;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
  print("Starting _checkAuth");
  final session = supabase.auth.currentSession;
  print("Current session: ${session?.user.id}");

  if (session == null) {
    print("No session, navigating to LoginScreen");
    _nextScreen = LoginScreen();
  } else {
    try {
      print("Fetching user data for ID: ${session.user.id}");
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', session.user.id)
          .single();
      
      print("User data fetched: $userData");
      print("Profile completed: ${userData['profile_completed']}");

      if (userData['profile_completed'] != true) {
        print("Profile not completed, should navigate to GettingUserDetails");
        _nextScreen = GettingUserDetails();
      } else {
        print("Profile completed, navigating to HomeScreen");
        _nextScreen = HomeScreen();
      }
    } catch (e) {
      print('Error checking user data: $e');
      _nextScreen = LoginScreen();
    }
  }

  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
  print("_checkAuth completed, _nextScreen is: ${_nextScreen.runtimeType}");
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Use Future.microtask to schedule navigation for after this frame
    Future.microtask(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _nextScreen!),
      );
    });

    // Return a loading screen while we wait for navigation
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}