import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/providers/user_provider.dart';
import 'package:wellnash_4/services/auth_services.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/auth_screens/signup_screen.dart';
import 'screens/auth_screens/getting_user_details.dart';
import 'screens/home_screen.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = json.decode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);

  await Supabase.initialize(
    url: 'https://kxkqsyzsudimqrqriguk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4a3FzeXpzdWRpbXFycXJpZ3VrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk3OTkxNjgsImV4cCI6MjAzNTM3NTE2OH0.jmlbjYldvrSgW-gmJOg7fGvVLrK7bU1BYdP9k7o_yPk',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, authService, previousUserProvider) => 
            UserProvider()..updateFromAuthService(authService),
        ),
      ],
      child: MyApp(theme: theme),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.theme}) : super(key: key);
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellnash',
      theme: theme,
      home: Consumer<AuthService>(
        builder: (context, authService, _) {
          if (authService.isAuthenticated) {
            // Fetch user data when authenticated
            Provider.of<UserProvider>(context, listen: false).fetchUser();
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/getting_user_details': (context) => GettingUserDetails(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}