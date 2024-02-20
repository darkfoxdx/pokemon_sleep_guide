import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class UserSetting extends ChangeNotifier {
  final Map<String, int> _ingredients = {};
  final Map<String, bool> _completedRecipes = {};
  RecipeType _recipeType = RecipeType.curry;

  UnmodifiableMapView<String, int> get ingredients =>
      UnmodifiableMapView(_ingredients);

  UnmodifiableMapView<String, bool> get completedRecipes =>
      UnmodifiableMapView(_completedRecipes);

  RecipeType get recipeType => _recipeType;

  UserSetting() {
    _ingredients.addAll(PreferenceUtils.getUserIngredients());
    _completedRecipes.addAll(PreferenceUtils.getCompletedRecipes());
    _recipeType = PreferenceUtils.getRecipeType();
  }

  void setRecipeType(RecipeType recipeType) {
    _recipeType = recipeType;
    PreferenceUtils.setRecipeType(recipeType);
    notifyListeners();
  }

  void setIngredient(String key, int quality) {
    _ingredients[key] = quality;
    PreferenceUtils.setIngredient(key, quality);
    notifyListeners();
  }

  void setCompletedRecipe(String key, bool completed) {
    _completedRecipes[key] = completed;
    PreferenceUtils.setCompletedRecipe(key, completed);
    notifyListeners();
  }
}
