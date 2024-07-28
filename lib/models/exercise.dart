class Exercise {
  late String id;
  final String name;
  final String? category;
  final String? description;
  final int? order;
  final List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    this.category,
    this.description,
    this.order,
    required this.sets,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
      order: json['order'] as int?,
      sets: (json['exercise_sets'] as List<dynamic>?)
          ?.map((setData) => ExerciseSet.fromJson(setData))
          .toList() ?? [],
    );
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? order,
    List<ExerciseSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      order: order ?? this.order,
      sets: sets ?? this.sets,
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
  late String id;
  final int setNumber;
  final int intensity;
  final double? targetWeight;
  final int? targetReps;
  double? actualWeight;
  int? actualReps;

  ExerciseSet({
    required this.id,
    required this.setNumber,
    this.intensity = 0,
    this.targetWeight,
    this.targetReps,
    this.actualWeight,
    this.actualReps,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'] as String,
      setNumber: json['set_number'] as int,
      intensity: json['intensity'] as int? ?? 0,
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      targetReps: json['target_reps'] as int?,
      actualWeight: (json['actual_weight'] as num?)?.toDouble(),
      actualReps: json['actual_reps'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'set_number': setNumber,
      'intensity': intensity,
      'target_weight': targetWeight,
      'target_reps': targetReps,
      'actual_weight': actualWeight,
      'actual_reps': actualReps,
    };
  }
}