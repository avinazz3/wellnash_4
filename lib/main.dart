import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/screens/signup_screen.dart';
import 'package:wellnash_4/screens/getting_user_details.dart'; 
import 'package:wellnash_4/screens/workout_preferences.dart'; 
import 'package:wellnash_4/services/auth_services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellnash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Updated to use initialRoute
      routes: {
        '/': (context) => Provider.of<UserProvider>(context).user.token.isEmpty ? SignupScreen() : HomeScreen(),
        '/getting_user_details': (context) => GettingUserDetails(), // New route
        '/workout_preferences': (context) => WorkoutPreferences(), // New route
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


