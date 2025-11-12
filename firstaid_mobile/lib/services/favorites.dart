import 'package:shared_preferences/shared_preferences.dart';

class Favorites {
  static const _key = 'favourite_injury';

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? <String>[];
  }

  static Future<void> save(List<String> names) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, names);
  }

  static Future<void> toggle(String name) async {
    final current = await load();
    if (current.contains(name)) {
      current.remove(name);
    } else {
      current.add(name);
    }
    await save(current);
  }

  static Future<bool> isFavourite(String name) async {
    final current = await load();
    return current.contains(name);
  }
}
