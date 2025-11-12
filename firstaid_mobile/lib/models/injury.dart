class Injury {
  final String name;
  final String? imageName;             
  final List<dynamic> steps;

  Injury({
    required this.name,
    required this.steps,
    this.imageName,
  });

  factory Injury.fromJson(Map<String, dynamic> json) {
    final String name = (json['name'] ?? '').toString().trim().isEmpty
        ? 'Unknown injury'
        : json['name'].toString();

    final dynamic rawImg = json.containsKey('image') ? json['image'] : json['imageName'];
    String? imageName;
    if (rawImg != null) {
      final s = rawImg.toString().trim();
      if (s.isNotEmpty) imageName = s;
    }

    final List<dynamic> steps = <dynamic>[];
    final rawSteps = json['steps'];
    if (rawSteps is List) {
      for (final s in rawSteps) {
        if (s is String) {
          steps.add(s);
        } else if (s is Map) {
          final txt = (s['text'] ?? '').toString();
          final img = (s['image'] == null || s['image'].toString().trim().isEmpty)
              ? null
              : s['image'].toString();
          final entry = <String, dynamic>{'text': txt};
          if (img != null) entry['image'] = img;
          if (s['timer'] is int) entry['timer'] = s['timer'];
          steps.add(entry);
        } else if (s != null) {
          steps.add(s.toString()); 
        }
      }
    }

    return Injury(name: name, imageName: imageName, steps: steps);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      if (imageName != null) 'image': imageName,
      'steps': steps,
    };
  }
}
