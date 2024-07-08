import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/screens/auth_screens/getting_user_details.dart';
import 'package:wellnash_4/screens/auth_screens/login_screen.dart';
import 'package:wellnash_4/screens/home_screen.dart';

class AuthService with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isAuthenticated = false;
  User? currentUser;
  
  AuthService() {
    currentUser = supabase.auth.currentUser;
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signUpUser(
      BuildContext context, String email, String password, String name) async {
    try {
      // Sign up the user using Supabase auth
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Insert the user data into the custom `users` table using the Supabase function
        await supabase.rpc('insert_user', params: {
          '_id': response.user!.id,
          '_email': email,
          '_name': name,
          '_password': password,
        });

        context.showSnackBar(
            'Account created successfully. Proceed to enter your details.');
        _isAuthenticated = true;
        notifyListeners();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GettingUserDetails()),
        );
      } else {
        context.showSnackBar('Sign up failed. Please try again.',
            isError: true);
      }
    } on AuthException catch (error) {
      context.showSnackBar(error.message, isError: true);
    } catch (error) {
      context.showSnackBar('Unexpected error occurred: ${error.toString()}',
          isError: true);
    }
  }

  Future<void> signInUser(
      BuildContext context, String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        _isAuthenticated = true;
        notifyListeners();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        context.showSnackBar('Sign in failed. Please try again.',
            isError: true);
      }
    } on AuthException catch (error) {
      context.showSnackBar(error.message, isError: true);
    } catch (error) {
      context.showSnackBar('Unexpected error occurred: ${error.toString()}',
          isError: true);
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      _isAuthenticated = false;
      notifyListeners();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Unexpected error occurred: ${error.toString()}', isError: true);
      }
    }
  }

  StreamSubscription<AuthState> authStateSubscription(
      BuildContext context, Function onRedirecting) {
    return supabase.auth.onAuthStateChange.listen(
      (data) {
        final session = data.session;
        if (session != null) {
          onRedirecting();
          _isAuthenticated = true;
          notifyListeners();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException) {
          context.showSnackBar(error.message, isError: true);
        } else {
          context.showSnackBar('Unexpected error occurred: ${error.toString()}',
              isError: true);
        }
      },
    );
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      context
          .showSnackBar('Password reset email sent. Please check your inbox.');
    } on AuthException catch (error) {
      context.showSnackBar(error.message, isError: true);
    } catch (error) {
      context.showSnackBar('Unexpected error occurred: ${error.toString()}',
          isError: true);
    }
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
