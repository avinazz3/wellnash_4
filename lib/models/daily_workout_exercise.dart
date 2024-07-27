class DailyWorkoutExercise {
  final String id;
  final String dailyWorkoutId;
  final String exerciseId;
  final int exerciseOrder;
  final double? targetWeight;
  final double? actualWeight;
  final int? sets;
  final int? reps;

  DailyWorkoutExercise({
    required this.id,
    required this.dailyWorkoutId,
    required this.exerciseId,
    required this.exerciseOrder,
    this.targetWeight,
    this.actualWeight,
    this.sets,
    this.reps,
  });

  factory DailyWorkoutExercise.fromJson(Map<String, dynamic> json) {
    return DailyWorkoutExercise(
      id: json['id'],
      dailyWorkoutId: json['dailyworkout_id'],
      exerciseId: json['exercise_id'],
      exerciseOrder: json['exercise_order'],
      targetWeight: json['target_weight'],
      actualWeight: json['actual_weight'],
      sets: json['sets'],
      reps: json['reps'],
    );
  }
}