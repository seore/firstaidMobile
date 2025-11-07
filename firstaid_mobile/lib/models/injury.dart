class Injury {
  final String name;
  final String imageName;
  final List<String> steps;

  Injury({required this.name, required this.imageName, required this.steps});

  factory Injury.fromJson(Map<String, dynamic> j) => Injury(
    name: j['name'],
    imageName: j['imageName'] ?? '',
    steps: List<String>.from(j['steps'] ?? []),
  );
}

