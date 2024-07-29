import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/auth_screens/getting_user_details.dart';
import 'package:wellnash_4/screens/auth_screens/login_screen.dart';
import 'package:wellnash_4/services/supabase_services.dart';
import 'package:wellnash_4/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();

  // Get Supabase instance
  final supabase = Supabase.instance.client;

Future<void> _signUp() async {
  if (!mounted) return;

  setState(() {
    _isLoading = true;
  });

  try {
    final AuthResponse res = await supabase.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res.user != null) {
      // Insert additional user details into your database
      await supabase.from('users').insert({
        'id': res.user!.id,
        'name': _nameController.text,
        'email': _emailController.text,
        'profile_completed': false,
        'password': _passwordController.text,
      });

      // Create workout log for the new user
      if (mounted) {
        await _supabaseService.createWorkoutLog(res.user!.id);
      }

      if (mounted) {
        // Navigate to getting user details screen
        print("Signup successful, navigating to GettingUserDetails");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GettingUserDetails()),
        );
      }
    } else {
      if (mounted) {
        showErrorSnackBar(context, message: 'Sign up failed. Please try again.');
      }
    }
  } on AuthException catch (error) {
    if (mounted) {
      showErrorSnackBar(context, message: error.message);
    }
  } catch (error) {
    if (mounted) {
      showErrorSnackBar(context, message: 'An unexpected error occurred');
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wellnash',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text(
            'SIGN UP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk_regular',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox(
              height: 600,
              width: 400,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset('assets/gym_login.png'),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
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
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Username'),
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
                  onPressed: _isLoading ? null : _signUp,
                  child: Text(_isLoading ? 'Signing Up...' : 'Sign Up'),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(double.infinity, 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    "Already have an account? Sign in here",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
