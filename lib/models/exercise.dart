class Exercise {
  final String id;
  final String name;
  final String? category; // e.g., 'Main lift', 'Accessory', etc.
  final String? description;
  final int order;
  final List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    this.category,
    this.description,
    required this.order,
    required this.sets,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      order: json['order'],
      sets: (json['sets'] as List<dynamic>)
          .map((setJson) => ExerciseSet.fromJson(setJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'order': order,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }
}

class ExerciseSet {
  final String id;
  final int setNumber;
  final int intensity;
  final double targetWeight;
  final int targetReps;
  double? actualWeight;
  int? actualReps;

  ExerciseSet({
    required this.id,
    required this.setNumber,
    this.intensity = 0, //ive set intensity to 0, because we dont exactly know how to figure it out yet
    required this.targetWeight,
    required this.targetReps,
    this.actualWeight,
    this.actualReps,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'],
      setNumber: json['setNumber'],
      intensity: json['intensity'],
      targetWeight: json['targetWeight'].toDouble(),
      targetReps: json['targetReps'],
      actualWeight: json['actualWeight']?.toDouble(),
      actualReps: json['actualReps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setNumber': setNumber,
      'intensity': intensity,
      'targetWeight': targetWeight,
      'targetReps': targetReps,
      'actualWeight': actualWeight,
      'actualReps': actualReps,
    };
  }
}