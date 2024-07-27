import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/auth_screens/signup_screen.dart';
import 'package:wellnash_4/screens/home_screen.dart';
import 'package:wellnash_4/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleError(dynamic error) {
  if (!mounted) return;
  
  if (error is AuthException) {
    showErrorSnackBar(context, message: error.message);
  } else {
    showErrorSnackBar(context, message: 'Unexpected error occurred');
  }
}

Future<void> _signIn() async {
  setState(() {
    _isLoading = true;
  });

  try {
    await Supabase.instance.client.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  } catch (error) {
    _handleError(error);
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

Future<void> _resetPassword() async {
  final email = _emailController.text.trim();
  if (email.isEmpty) {
    _handleError(const AuthException('Please enter your email'));
    return;
  }

  try {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
    if (mounted) {
      showSnackBar(context, message: 'Password reset email sent');
    }
  } catch (error) {
    _handleError(error);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellnash', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const SizedBox(height: 18),
          Center(
            child: Container(
              height: 400,
              width: 400,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset('assets/gym_login.png'),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 400,
            width: 400,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'SIGN IN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'SpaceGrotesk_regular', fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: Text(_isLoading ? 'Signing In...' : 'Sign In'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(double.infinity, 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text("Don't have an account? Sign up here", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(double.infinity, 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Reset Password', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
