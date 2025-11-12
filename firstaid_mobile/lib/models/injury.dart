class Injury {
  final String name;
  /// Optional icon / thumbnail for the injury as a whole
  final String? imageName;
  /// Each step is a map: { "text": "...", "imageName": "...", "timerSeconds": 600 }
  final List<Map<String, dynamic>> steps;

  Injury({
    required this.name,
    this.imageName,
    required this.steps,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    // 1. Read raw steps list (could be list of Maps or Strings)
    final rawSteps = json['steps'] as List<dynamic>? ?? [];

    // 2. Normalise each entry into a Map<String, dynamic>
    final stepMaps = rawSteps.map<Map<String, dynamic>>((e) {
      if (e is Map<String, dynamic>) {
        return e;
      }
      if (e is Map) {
        // convert loosely typed map into a proper one
        return Map<String, dynamic>.from(e);
      }
      if (e is String) {
        // backwards-compatible: old data where step was just text
        return <String, dynamic>{'text': e};
      }
      // ultimate fallback
      return <String, dynamic>{'text': e.toString()};
    }).toList();

    return Injury(
      name: json['name'] as String? ?? 'Unnamed injury',
      // support both "imageName" (new) and "image" (old)
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
