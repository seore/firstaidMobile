import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  final String name;
  final String bloodType;
  final String allergies;
  final String emergencyContact;

  Profile({
    this.name = '',
    this.bloodType = '',
    this.allergies = '',
    this.emergencyContact = '',
  });

  Profile copyWith ({
    String? name,
    String? bloodType,
    String? allergies,
    String? emergencyContact,
  }) {
    return Profile(
      name: name ?? this.name,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }
}

class ProfileService {
  static const _kName = 'profile_name';
  static const _kBlood = 'profile_blood_type';
  static const _kAllergies = 'profile_allergies';
  static const _kEmergencyContact = 'profile_emergency_contact';

  static Future<Profile> load() async {
    final sp = await SharedPreferences.getInstance();
    return Profile(
      name: sp.getString(_kName) ?? '',
      bloodType: sp.getString(_kBlood) ?? '',
      allergies: sp.getString(_kAllergies) ?? '',
      emergencyContact: sp.getString(_kEmergencyContact) ?? '',
    );
  }

  static Future<void> save(Profile profile) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kName, profile.name);
    await sp.setString(_kBlood, profile.bloodType);
    await sp.setString(_kAllergies, profile.allergies);
    await sp.setString(_kEmergencyContact, profile.emergencyContact);
  }
}