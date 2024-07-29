import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screens/auth_check_screen.dart';
import 'appainter_theme.dart'; // Ensure this import is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kxkqsyzsudimqrqriguk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4a3FzeXpzdWRpbXFycXJpZ3VrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk3OTkxNjgsImV4cCI6MjAzNTM3NTE2OH0.jmlbjYldvrSgW-gmJOg7fGvVLrK7bU1BYdP9k7o_yPk',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthCheckScreen(),
      theme: buildTheme(), // Ensure this calls the correct function
    );
  }
}