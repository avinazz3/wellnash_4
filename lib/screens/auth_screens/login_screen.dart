import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wellnash_4/screens/auth_screens/signup_screen.dart';
import 'package:wellnash_4/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _redirecting = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _onRedirecting() {
    _redirecting = true;
  }

  @override
  void initState() {
    super.initState();
    _authService.authStateSubscription(context, _onRedirecting);
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
              height: 400, // Adjust height as needed
              width: 400,  // Adjust width as needed
              child: FittedBox(
                fit: BoxFit.cover, // Use BoxFit.cover to zoom in
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          _authService
                              .signInUser(
                            context,
                            _emailController.text,
                            _passwordController.text,
                          )
                              .then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
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
                    minimumSize: const Size(double.infinity, 20), // Set the desired width and height here
                    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding as needed
                  ),
                  child: const Text("Don't have an account? Sign up here", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    _authService.resetPassword(context, email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(double.infinity, 20), // Set the desired width and height here
                    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding as needed
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
