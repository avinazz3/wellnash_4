import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/user.dart' as models;
import 'package:wellnash_4/screens/auth_screens/getting_user_details.dart';
import 'package:wellnash_4/screens/auth_screens/login_screen.dart';
import 'package:wellnash_4/screens/home_screen.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  models.User? _user;
  models.User? get currentUser => _user;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    // Set up the auth state listener in the constructor
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            _isAuthenticated = true;
            fetchUser();
          }
          break;
        case AuthChangeEvent.signedOut:
          _isAuthenticated = false;
          _user = null;
          break;
        default:
          break;
      }
      notifyListeners();
    }, onError: (error) {
      print('Auth state change error: $error');
    });
  }

  // Method to check initial auth state
  Future<void> checkInitialAuthState() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _isAuthenticated = true;
      await fetchUser();
    }
    notifyListeners();
  }

  Future<bool> signUpUser(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.rpc('insert_user', params: {
          '_id': response.user!.id,
          '_email': email,
          '_name': name,
          '_password': password,
        });

        _user = models.User(
          id: response.user!.id,
          email: email,
          name: name,
          password: password,
        );

        _isAuthenticated = true;
        notifyListeners();
        return true; // Indicate successful sign-up
      } else {
        throw Exception('Sign up failed');
      }
    } catch (error) {
      print('Error during sign up: $error');
      return false; // Indicate failed sign-up
    }
  }

  Future<void> signUpUser2(
      BuildContext context, String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await supabase.rpc('insert_user', params: {
          '_id': response.user!.id,
          '_email': email,
          '_name': name,
          '_password': password,
        });

        // Initialize the User model
      _user = models.User(
        id: response.user!.id,
        email: email,
        name: name,
        password: password,
        // Other fields will be null initially
      );

        _isAuthenticated = true;
        notifyListeners();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GettingUserDetails()),
            (route) => false,
          );
          context.showSnackBar(
              'Account created successfully. Proceed to enter your details.');
        });
      } else {
        throw Exception('Sign up failed');
      }
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.showSnackBar('Error: ${error.toString()}', isError: true);
      });
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      } else {
        throw Exception('Sign in failed');
      }
      
    } catch (error) { //this is line 153
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.showSnackBar('Error: ${error.toString()}', isError: true);
      });
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Error: ${error.toString()}', isError: true);
      }
    }
  }

void initAuthListener(BuildContext context) {
  supabase.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;

    switch (event) {
      case AuthChangeEvent.signedIn:
        if (session != null) {
          _isAuthenticated = true;
          fetchUser().then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
          });
        }
        break;
      case AuthChangeEvent.signedOut:
        _isAuthenticated = false;
        _user = null;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
        break;
      default:
        break;
    }
  }, onError: (error) {
    print('Auth state change error: $error');
  });

  // Check initial auth state
  final user = supabase.auth.currentUser;
  if (user != null) {
    _isAuthenticated = true;
    fetchUser().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
  }
}

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      context
          .showSnackBar('Password reset email sent. Please check your inbox.');
    } catch (error) {
      context.showSnackBar('Error: ${error.toString()}', isError: true);
    }
  }

  Future<void> fetchUser() async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) {
      _user = null;
      return;
    }

    final response = await supabase
      .from('users')
      .select()
      .eq('id', user.id)
      .single();

    _user = models.User(
      id: user.id,
      email: user.email ?? '',
      name: response['name'] ?? '',
      password: response['password'] ?? '',
      profilePictureUrl: response['profile_picture_url'],
      goals: response['goals'],
      workoutDays: response['workout_days'],
      workoutRegime: response['workout_regime'],
      currentWorkoutPlan: response['current_workout_plan'],
      height: response['height']?.toDouble(),
      weight: response['weight']?.toDouble(),
      activityLevel: response['activity_level'],
    );

    notifyListeners();
  } catch (error) {
    print('Error fetching user data: $error');
    rethrow;
  }
}
  Future<void> updateUser(String field, dynamic value) async {
    try {
      await supabase.from('users').update({field: value}).eq('id', _user!.id);

      await fetchUser();
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  Future<void> updateHeight(double height) async {
    await updateUser('height', height);
  }

  Future<void> updateWeight(double weight) async {
    await updateUser('weight', weight);
  }

  Future<void> updateWorkoutDays(int workoutDays) async {
    await updateUser('workout_days', workoutDays);
  }

  Future<void> updateWorkoutRegime(int? workoutRegimeId) async {
    await updateUser('workout_regime_id', workoutRegimeId);
  }

  Future<void> updateEmail(String email) async {
    await updateUser('email', email);
  }

  Future<void> updateUsername(String username) async {
    await updateUser('name', username);
  }

  Future<void> updateGoals(String? goals) async {
    await updateUser('goals', goals);
  }

  Future<void> updateActivityLevel(String? activityLevel) async {
    await updateUser('activity_level', activityLevel);
  }

  Future<void> updateMultipleFields(Map<String, dynamic> updates) async {
    try {
      await supabase.from('users').update(updates).eq('id', _user!.id);

      await fetchUser();
    } catch (error) {
      print('Error updating multiple fields: $error');
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
