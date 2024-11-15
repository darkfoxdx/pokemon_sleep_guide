import 'dart:async' show Future;
import 'dart:convert';
import 'package:pokemon_sleep_guide/model/bookmark_state.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/sort_order.dart';
import 'package:pokemon_sleep_guide/model/sort_type.dart';
import 'package:pokemon_sleep_guide/utils/constants.dart';
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
  static const _dataFilteredIngredients = "filtered_out_ingredients";
  static const _dataBookmarkState = "bookmark_state";
  static const _dateSortType = "sort_type";
  static const _dateSortOrder = "sort_order";
  static const _dataOptimizePotSize = "optimize_pot_size";


  static List<String> getFilteredIngredients() {
    var listString = _prefsInstance?.getString(_dataFilteredIngredients);
    if (listString == null) return <String>[];
    List<String> list = List.castFrom(json.decode(listString));
    return list;
  }

  static Future<bool> setFilteredIngredients(List<String> list) async {
    var prefs = await _instance;
    return prefs.setString(_dataFilteredIngredients, json.encode(list));
  }

  static Future<bool> addFilteredIngredient(String value) async {
    var list = getFilteredIngredients();
    list.add(value);
    var prefs = await _instance;
    return prefs.setString(_dataFilteredIngredients, json.encode(list));
  }

  static Future<bool> removeFilteredIngredient(String value) async {
    var list = getFilteredIngredients();
    list.remove(value);
    var prefs = await _instance;
    return prefs.setString(_dataFilteredIngredients, json.encode(list));
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

  static List<String> getCompletedRecipes() {
    var listString = _prefsInstance?.getString(_dataCompletedRecipes);
    if (listString == null) return <String>[];
    var decode = json.decode(listString);
    List<String> list = [];
    if (decode is List) {
      list = List.castFrom(decode);
    } else if (decode is Map) {
      // Convert from old data
      Map<String, bool> map = Map.castFrom(decode);
      list = map.entries
          .where((element) => element.value)
          .map((e) => e.key)
          .toList();
    }

    return list;
  }

  static Future<bool> setCompletedRecipes(List<String> list) async {
    var prefs = await _instance;
    return prefs.setString(_dataCompletedRecipes, json.encode(list));
  }

  static Future<bool> addCompletedRecipe(String value) async {
    var list = getCompletedRecipes();
    list.add(value);
    var prefs = await _instance;
    return prefs.setString(_dataCompletedRecipes, json.encode(list));
  }

  static Future<bool> removeCompletedRecipe(String value) async {
    var list = getCompletedRecipes();
    list.remove(value);
    var prefs = await _instance;
    return prefs.setString(_dataCompletedRecipes, json.encode(list));
  }

  static RecipeType getRecipeType() {
    int recipeType = _prefsInstance?.getInt(_dataRecipeType) ?? 0;
    return RecipeType.values[recipeType];
  }

  static Future<bool> setRecipeType(RecipeType type) async {
    var prefs = await _instance;
    return prefs.setInt(_dataRecipeType, type.index);
  }

  static BookmarkState getBookmarkState() {
    int bookmarkState = _prefsInstance?.getInt(_dataBookmarkState) ?? 0;
    return BookmarkState.values[bookmarkState];
  }

  static Future<bool> setBookmarkState(BookmarkState state) async {
    var prefs = await _instance;
    return prefs.setInt(_dataBookmarkState, state.index);
  }

  static SortOrder getSortOrder() {
    int sortOrder = _prefsInstance?.getInt(_dateSortOrder) ?? 0;
    return SortOrder.values[sortOrder];
  }

  static Future<bool> setSortOrder(SortOrder sortOrder) async {
    var prefs = await _instance;
    return prefs.setInt(_dateSortOrder, sortOrder.index);
  }

  static SortType getSortType() {
    int sortType = _prefsInstance?.getInt(_dateSortType) ?? 0;
    return SortType.values[sortType];
  }

  static Future<bool> setSortType(SortType sortType) async {
    var prefs = await _instance;
    return prefs.setInt(_dateSortType, sortType.index);
  }

  static int getOptimizePotSize() {
    int optimizePotSize = _prefsInstance?.getInt(_dataOptimizePotSize) ?? Constants.potSize[0];
    return optimizePotSize;
  }

  static Future<bool> setOptimizePotSize(int potSize) async {
    var prefs = await _instance;
    return prefs.setInt(_dataOptimizePotSize, potSize);
  }
}
