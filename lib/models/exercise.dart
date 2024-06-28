class Exercise {
  final String name;
  final List<ExerciseSet> sets;

  Exercise({required this.name, required this.sets});
}

class ExerciseSet {
  final int intensity;
  final double targetKg;
  final int reps;
  double? actualKg;
  int? actualReps;

  ExerciseSet({required this.intensity, required this.targetKg, required this.reps});
}
