import 'dart:convert';

class User {
  final int id;
  final String? email;
  final String name;
  final String? password;
  final String? profilePictureUrl;
  final String? oauthProvider;
  final double height;
  final double weight;
  final String? activityLevel;
  final Map<String, dynamic>? injuries; 
  final String? goals;
  final int workoutDays;
  final int? workoutRegimeId;
  final int? currentWorkoutPlanId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.password,
    this.profilePictureUrl,
    this.oauthProvider,
    this.activityLevel,
    required this.height,
    required this.weight,
    this.injuries,
    this.goals,
    required this.workoutDays,
    this.workoutRegimeId,
    this.currentWorkoutPlanId,
    this.createdAt,
    this.updatedAt,
    required this.token,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'] ?? '',
      name: map['name'],
      password: map['password'],
      profilePictureUrl: map['profile_picture_url'],
      oauthProvider: map['oauth_provider'],
      height: map['height'],
      weight: map['weight'],
      injuries: map['injuries'],
      goals: map['goals'],
      workoutDays: map['workout_days'],
      workoutRegimeId: map['workout_regime_id'],
      currentWorkoutPlanId: map['current_workout_plan_id'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      token: map['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'profile_picture_url': profilePictureUrl,
      'oauth_provider': oauthProvider,
      'injuries': injuries,
      'goals': goals,
      'workout_days': workoutDays,
      'workout_regime_id': workoutRegimeId,
      'current_workout_plan_id': currentWorkoutPlanId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'token': token,
      'height': height,
      'weight': weight,
      'activity_level': activityLevel ?? '',
    };
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
