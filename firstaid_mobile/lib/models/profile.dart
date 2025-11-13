class Profile {
  final String name;
  final String bloodType;
  final String allergies;
  final String emergencyContact;
  final String lastUpdated;

  Profile({
    required this.name,
    required this.bloodType,
    required this.allergies,
    required this.emergencyContact,
    required this.lastUpdated,
  });

  /// Empty/default profile – used when nothing is saved yet
  factory Profile.empty() => Profile(
        name: '',
        bloodType: '',
        allergies: '',
        emergencyContact: '',
        lastUpdated: '',
      );

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      bloodType: json['bloodType'] ?? '',
      allergies: json['allergies'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'lastUpdated': lastUpdated,
    };
  }
}
