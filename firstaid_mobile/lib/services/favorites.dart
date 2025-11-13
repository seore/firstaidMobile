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

  static Future<bool> toggle(String name) async {
    final current = await load();
    bool nowFav;

    if (current.contains(name)) {
      current.remove(name);
      nowFav = false;
    } else {
      current.add(name);
      nowFav = true;
    }
    await save(current);
    return nowFav;
  }

  static Future<bool> isFavourite(String name) async {
    final current = await load();
    return current.contains(name);
  }
}
