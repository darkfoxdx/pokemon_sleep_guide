import 'dart:async' show Future;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static Map<String, int> getUserIngredients() {
    var mapString = _prefsInstance?.getString("user_ingredients");
    if (mapString == null) return <String, int>{};
    Map<String, int> map = Map.castFrom(json.decode(mapString));
    return map;
  }

  static Future<bool> setIngredient(String key, int quality) async {
    var map = getUserIngredients();
    map[key] = quality;
    var prefs = await _instance;
    return prefs.setString("user_ingredients", json.encode(map));
  }
}
