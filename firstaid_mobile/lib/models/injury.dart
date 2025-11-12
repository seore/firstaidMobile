class Injury {
  final String name;
  final String? imageName;
  final List<Map<String, dynamic>> steps;

  Injury({
    required this.name,
    this.imageName,
    required this.steps,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'] as List<dynamic>? ?? [];
    final stepMaps = rawSteps.map<Map<String, dynamic>>((e) {
      if (e is Map<String, dynamic>) {
        return e;
      }
      if (e is Map) {
        return Map<String, dynamic>.from(e);
      }
      if (e is String) {
        return <String, dynamic>{'text': e};
      }
      return <String, dynamic>{'text': e.toString()};
    }).toList();

    return Injury(
      name: json['name'] as String? ?? 'Unnamed injury',
      imageName: (json['imageName'] ?? json['image']) as String?,
      steps: stepMaps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (imageName != null) 'imageName': imageName,
      'steps': steps,
    };
  }
}
