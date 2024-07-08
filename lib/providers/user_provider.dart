import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnash_4/models/user.dart' as models; // Apply a prefix to the User import
import 'package:wellnash_4/services/auth_services.dart'; // Apply a prefix to the gotrue User import

class UserProvider extends ChangeNotifier {
  models.User? _user;
  models.User? get user => _user;

  void setUser(models.User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single();
      
      if (response['id'] != null) {
        _user = models.User.fromMap(response);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> updateUser(String field, dynamic value) async {
    try {
      await Supabase.instance.client
          .from('users')
          .update({field: value})
          .eq('id', _user!.id);
      
      await fetchUser(); // Refresh user data
    } catch (e) {
      print('Error updating user: $e');
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
    try {
      // Update email in Supabase Auth -> just dont allow users to change email for now!
      //await Supabase.instance.client.auth.update(email: email);
      // Update email in the users table
      await updateUser('email', email);
    } catch (e) {
      print('Error updating email: $e');
      // Handle the error (e.g., show an error message to the user)
    }
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
      await Supabase.instance.client
          .from('users')
          .update(updates)
          .eq('id', _user!.id);
      
      await fetchUser(); // Refresh user data
    } catch (e) {
      print('Error updating multiple fields: $e');
    }
  }

  void updateFromAuthService(AuthService authService) {
    if (authService.isAuthenticated) {
      fetchUser();
    } else {
      _user = null;
    }
  }
}