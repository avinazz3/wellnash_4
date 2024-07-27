import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class User {
  final String id;
  final String email;
  final String name;
  final String? profilePictureUrl;
  final String? goals;
  final int? workoutDays;
  final String? workoutRegime;
  final String? currentWorkoutPlan;
  final double? height;
  final double? weight;
  final String? activityLevel;
  final String password;
  bool profileCompleted = false;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    this.profilePictureUrl,
    this.goals,
    this.workoutDays,
    this.workoutRegime,
    this.currentWorkoutPlan,
    this.height,
    this.weight,
    this.activityLevel,
    this.profileCompleted = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      profilePictureUrl: json['profile_picture_url'],
      goals: json['goals'],
      workoutDays: json['workout_days'],
      workoutRegime: json['workout_regime'],
      currentWorkoutPlan: json['current_workout_plan'],
      height: json['height'],
      weight: json['weight'],
      activityLevel: json['activity_level'],
      profileCompleted: json['profile_completed'] ?? false,
    );
  }

  factory User.fromSupabaseUser(supabase.User supabaseUser, Map<String, dynamic> userData) {
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      name: userData['name'] ?? '',
      password: userData['password'] ?? '',
      profilePictureUrl: userData['profile_picture_url'],
      goals: userData['goals'],
      workoutDays: userData['workout_days'] != null ? int.tryParse(userData['workout_days'].toString()) : null,
      workoutRegime: userData['workout_regime'],
      currentWorkoutPlan: userData['current_workout_plan'],
      height: userData['height'] != null ? double.tryParse(userData['height'].toString()) : null,
      weight: userData['weight'] != null ? double.tryParse(userData['weight'].toString()) : null,
      activityLevel: userData['activity_level'],
      profileCompleted: userData['profile_completed'] ?? false,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'] ?? '',
      name: map['name'],
      password: map['password'],
      profilePictureUrl: map['profile_picture_url'],
      height: map['height'],
      weight: map['weight'],
      goals: map['goals'],
      workoutDays: map['workout_days'],
      workoutRegime: map['workout_regime_id'],
      currentWorkoutPlan: map['current_workout_plan'],
      activityLevel: map['activity_level'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'profile_picture_url': profilePictureUrl,
      'goals': goals,
      'workout_days': workoutDays,
      'workout_regime_id': workoutRegime,
      'current_workout_plan_id': currentWorkoutPlan,
      'height': height,
      'weight': weight,
      'activity_level': activityLevel ?? '',
    };
  }
}


