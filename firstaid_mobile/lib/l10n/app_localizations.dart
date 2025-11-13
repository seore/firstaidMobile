import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'app_title': 'Aidly',
      'home_normal': 'Home',
      'emergency_mode': 'Emergency mode',
      'profile_title': 'My Profile',
    },
    'yo': {
      'app_title': 'Aidly',
      'home_normal': 'Kọ́ & Ṣe adaṣe',
      'emergency_mode': 'Ìpinnu pajawiri',
      'profile_title': 'Profaili Mi',
    },
    'fr': {
      'app_title': 'Aidly',
      'home_learn_practice': 'Apprendre & Pratiquer',
      'emergency_mode': 'Mode urgence',
      'profile_title': 'Mon profil',
    },
  };

  String tr(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'yo', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}