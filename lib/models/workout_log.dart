class WorkoutLog {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutLog({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}