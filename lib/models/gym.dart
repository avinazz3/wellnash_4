class Gym {
  final String id;
  final String name;
  final String? location;

  Gym({
    required this.id,
    required this.name,
    this.location,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}