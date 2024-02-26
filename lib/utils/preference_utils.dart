import 'dart:async' show Future;
import 'dart:convert';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
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

  static const _dataUserIngredients = "user_ingredients";
  static const _dataRecipeType = "recipe_type";
  static const _dataCompletedRecipes = "completed_recipes";
  static const _dataFilteredOutIngredients = "filtered_out_ingredients";

  static List<String> getFilteredOutIngredients() {
    var listString = _prefsInstance?.getString(_dataFilteredOutIngredients);
    if (listString == null) return <String>[];
    List<String> list = List.castFrom(json.decode(listString));
    return list;
  }

  static Future<bool> setFilteredOutIngredients(List<String> list) async {
    var prefs = await _instance;
    return prefs.setString(_dataFilteredOutIngredients, json.encode(list));
  }

  static Future<bool> addFilteredOutIngredient(String value) async {
    var list = getFilteredOutIngredients();
    list.add(value);
    var prefs = await _instance;
    return prefs.setString(_dataFilteredOutIngredients, json.encode(list));
  }

  static Future<bool> removeFilteredOutIngredient(String value) async {
    var list = getFilteredOutIngredients();
    list.remove(value);
    var prefs = await _instance;
    return prefs.setString(_dataFilteredOutIngredients, json.encode(list));
  }

  static Map<String, int> getUserIngredients() {
    var mapString = _prefsInstance?.getString(_dataUserIngredients);
    if (mapString == null) return <String, int>{};
    Map<String, int> map = Map.castFrom(json.decode(mapString));
    return map;
  }

  static Future<bool> setIngredient(String key, int quality) async {
    var map = getUserIngredients();
    map[key] = quality;
    var prefs = await _instance;
    return prefs.setString(_dataUserIngredients, json.encode(map));
  }

  static Future<bool> clearIngredients() async {
    var map = <String, int>{};
    var prefs = await _instance;
    return prefs.setString(_dataUserIngredients, json.encode(map));
  }

  static Map<String, bool> getCompletedRecipes() {
    var mapString = _prefsInstance?.getString(_dataCompletedRecipes);
    if (mapString == null) return <String, bool>{};
    Map<String, bool> map = Map.castFrom(json.decode(mapString));
    return map;
  }

  static Future<bool> setCompletedRecipe(String key, bool completed) async {
    var map = getCompletedRecipes();
    map[key] = completed;
    var prefs = await _instance;
    return prefs.setString(_dataCompletedRecipes, json.encode(map));
  }

  static RecipeType getRecipeType() {
    int recipeType = _prefsInstance?.getInt(_dataRecipeType) ?? 0;
    return RecipeType.values[recipeType];
  }

  static Future<bool> setRecipeType(RecipeType type) async {
    var prefs = await _instance;
    return prefs.setInt(_dataRecipeType, type.index);
  }
}
