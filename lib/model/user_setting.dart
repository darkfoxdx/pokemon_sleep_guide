import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class UserSetting extends ChangeNotifier {
  final Map<String, int> _userIngredients = {};
  final Map<String, bool> _completedRecipes = {};
  final List<String> _filteredOutIngredients = [];
  RecipeType _recipeType = RecipeType.curry;

  UnmodifiableMapView<String, int> get userIngredients =>
      UnmodifiableMapView(_userIngredients);

  UnmodifiableMapView<String, bool> get completedRecipes =>
      UnmodifiableMapView(_completedRecipes);

  UnmodifiableListView<String> get filteredOutIngredients =>
      UnmodifiableListView(_filteredOutIngredients);

  RecipeType get recipeType => _recipeType;

  UserSetting() {
    _userIngredients.addAll(PreferenceUtils.getUserIngredients());
    _completedRecipes.addAll(PreferenceUtils.getCompletedRecipes());
    _recipeType = PreferenceUtils.getRecipeType();
    _filteredOutIngredients.addAll(PreferenceUtils.getFilteredOutIngredients());
  }

  void setFilteredOutIngredients(List<String> list) {
    _filteredOutIngredients.clear();
    _filteredOutIngredients.addAll(list);
    PreferenceUtils.setFilteredOutIngredients(list);
    notifyListeners();
  }

  void syncFilterOutIngredients(List<Ingredient> ingredients) {
    Set<String> ingredientsStringSet = ingredients.map((e) => e.name).toSet();
    Iterable<String> userIngredientsStringIterable = _userIngredients.keys;
    ingredientsStringSet.removeAll(userIngredientsStringIterable);
    setFilteredOutIngredients(ingredientsStringSet.toList());
  }

  void addFilteredOutIngredient(String name) {
    _filteredOutIngredients.add(name);
    PreferenceUtils.addFilteredOutIngredient(name);
    notifyListeners();
  }

  void removeFilteredOutIngredient(String name) {
    _filteredOutIngredients.remove(name);
    PreferenceUtils.removeFilteredOutIngredient(name);
    notifyListeners();
  }

  void setRecipeType(RecipeType recipeType) {
    _recipeType = recipeType;
    PreferenceUtils.setRecipeType(recipeType);
    notifyListeners();
  }

  void setIngredient(String key, int quality) {
    _userIngredients[key] = quality;
    PreferenceUtils.setIngredient(key, quality);
    notifyListeners();
  }

  void clearIngredients() {
    _userIngredients.clear();
    PreferenceUtils.clearIngredients();
    notifyListeners();
  }

  void setCompletedRecipe(String key, bool completed) {
    _completedRecipes[key] = completed;
    PreferenceUtils.setCompletedRecipe(key, completed);
    notifyListeners();
  }
}
