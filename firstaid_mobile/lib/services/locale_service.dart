import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _key = 'selected_locale_code';

  static Future<String?> loadLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> saveLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}
