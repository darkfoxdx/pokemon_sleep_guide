import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/data.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class UserSetting extends ChangeNotifier {
  List<Ingredient> _ingredients = [];
  Recipes _recipes = Recipes.empty();

  UnmodifiableListView<Ingredient> get ingredients =>
      UnmodifiableListView(_ingredients);

  Recipes get recipes => _recipes;

  final Map<String, int> _userIngredients = {};
  final Map<String, bool> _completedRecipes = {};
  final List<String> _filteredIngredients = [];
  RecipeType _recipeType = RecipeType.curry;

  UnmodifiableMapView<String, int> get userIngredients =>
      UnmodifiableMapView(_userIngredients);

  UnmodifiableMapView<String, bool> get completedRecipes =>
      UnmodifiableMapView(_completedRecipes);

  UnmodifiableListView<String> get filteredIngredients =>
      UnmodifiableListView(_filteredIngredients);

  RecipeType get recipeType => _recipeType;

  UserSetting() {
    _userIngredients.addAll(PreferenceUtils.getUserIngredients());
    _completedRecipes.addAll(PreferenceUtils.getCompletedRecipes());
    _recipeType = PreferenceUtils.getRecipeType();
    _filteredIngredients.addAll(PreferenceUtils.getFilteredIngredients());
  }

  void update(Data data) {
    _ingredients.clear();
    _ingredients.addAll(data.ingredients);
    _recipes = data.recipes;
    notifyListeners();
  }

  void setFilteredOutIngredients(List<String> list) {
    _filteredIngredients.clear();
    _filteredIngredients.addAll(list);
    PreferenceUtils.setFilteredIngredients(list);
    notifyListeners();
  }

  void syncFilterIngredients() {
    Iterable<String> userIngredientsStringIterable = _userIngredients.entries
        .where((element) => element.value != 0)
        .map((e) => e.key);
    setFilteredOutIngredients(userIngredientsStringIterable.toList());
  }

  void clearFilterIngredients() {
    setFilteredOutIngredients(<String>[]);
  }

  void addFilteredIngredient(String name) {
    _filteredIngredients.add(name);
    PreferenceUtils.addFilteredIngredient(name);
    notifyListeners();
  }

  void removeFilteredIngredient(String name) {
    _filteredIngredients.remove(name);
    PreferenceUtils.removeFilteredIngredient(name);
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

  int get recipeListLength => getList().length;
  int get currentListLength => generateCurrentList().length;

  List<Recipe> getList() {
    switch (recipeType) {
      case RecipeType.curry:
        return recipes.curryDishes;
      case RecipeType.salad:
        return recipes.saladDishes;
      case RecipeType.dessert:
        return recipes.dessertDishes;
    }
  }

  List<Recipe> generateCurrentList() {
    List<Recipe> selectedRecipe = getList();
    if (filteredIngredients.isNotEmpty) {
      selectedRecipe = selectedRecipe
          .where((element) =>
              element.ingredients.isEmpty ||
              element.ingredients.every(
                  (element) => filteredIngredients.contains(element.name)))
          .toList();
    }
    selectedRecipe.sort((b, a) => a
        .ingredientValue(userIngredients)
        .compareTo(b.ingredientValue(userIngredients)));
    return selectedRecipe;
  }

  Map<String, int> generateIngredientRecipeCount(
      BuildContext context, List<Recipe> selectedRecipe) {
    Map<String, int> ingredientRecipeCount = selectedRecipe.fold(
      <String, int>{},
      (previousValue, recipe) {
        List<String> ingredients = recipe.uniqueIngredients;
        for (var ingredient in ingredients) {
          int previousCount = previousValue[ingredient] ?? 0;
          previousValue[ingredient] = previousCount + 1;
        }
        return previousValue;
      },
    );
    return ingredientRecipeCount;
  }
}
