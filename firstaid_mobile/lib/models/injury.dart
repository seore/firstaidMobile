class Injury {
  final String name;
  final String imageName;
  final List<Map<String, dynamic>> steps;

  Injury({
    required this.name,
    required this.imageName,
    required this.steps,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
      name: json['name'] as String,
      imageName: json['image'] as String,
      steps: (json['steps'] as List<dynamic>)
    .map((e) => Map<String, dynamic>.from(e as Map))
    .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': imageName,
      'steps': steps,
    };
  }
}
