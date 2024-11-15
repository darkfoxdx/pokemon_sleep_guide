import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/bookmark_state.dart';
import 'package:pokemon_sleep_guide/model/data.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/model/sort_order.dart';
import 'package:pokemon_sleep_guide/model/sort_type.dart';
import 'package:pokemon_sleep_guide/utils/constants.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class UserSetting extends ChangeNotifier {
  final List<Ingredient> _ingredients = [];
  Recipes _recipes = Recipes.empty();

  UnmodifiableListView<Ingredient> get ingredients =>
      UnmodifiableListView(_ingredients);

  Recipes get recipes => _recipes;

  Map<String, dynamic> get exportData => {
        "userIngredients": _userIngredients,
        "completedRecipes": _completedRecipes,
      };

  void readExportedData(Map<String, dynamic> exportedData) {
    var userIngredients = exportData["userIngredients"];
    _userIngredients.clear();
    _userIngredients.addAll(userIngredients);

    var completedRecipes = exportData["completedRecipes"];
    _recipes = completedRecipes;

    notifyListeners();
  }

  int _optimizePotSize = Constants.potSize[0];
  SortOrder _sortOrder = SortOrder.asc;
  SortType _sortType = SortType.avail;
  final Map<String, int> _userIngredients = {};
  final List<String> _completedRecipes = [];
  final List<String> _filteredIngredients = [];
  RecipeType _recipeType = RecipeType.curry;
  BookmarkState _bookmarkState = BookmarkState.all;

  int get optimizePotSize => _optimizePotSize;

  SortOrder get sortOrder => _sortOrder;
  SortType get sortType => _sortType;

  UnmodifiableMapView<String, int> get userIngredients =>
      UnmodifiableMapView(_userIngredients);

  UnmodifiableListView<String> get completedRecipes =>
      UnmodifiableListView(_completedRecipes);

  UnmodifiableListView<String> get filteredIngredients =>
      UnmodifiableListView(_filteredIngredients);

  RecipeType get recipeType => _recipeType;

  BookmarkState get bookmarkState => _bookmarkState;

  UserSetting(String? data) {
    _recipeType = PreferenceUtils.getRecipeType();
    _bookmarkState = PreferenceUtils.getBookmarkState();
    _filteredIngredients.addAll(PreferenceUtils.getFilteredIngredients());
    _optimizePotSize = PreferenceUtils.getOptimizePotSize();

    if (data != null) {
      var json = jsonDecode(data);
      _userIngredients.addAll(Map.castFrom(json["userIngredients"]));
      _completedRecipes.addAll(List.castFrom(json["completedRecipes"]));
    } else {
      _userIngredients.addAll(PreferenceUtils.getUserIngredients());
      _completedRecipes.addAll(PreferenceUtils.getCompletedRecipes());
    }
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

  void setOptimizePotSize(int potSize) {
    _optimizePotSize = potSize;
    PreferenceUtils.setOptimizePotSize(potSize);
    notifyListeners();
  }

  void setSortType(SortType sortType) {
    _sortType = sortType;
    PreferenceUtils.setSortType(sortType);
    notifyListeners();
  }

  void toggleSortOrder() {
    List<SortOrder> orders = SortOrder.values;
    int newIndex = (_sortOrder.index + 1) % orders.length;
    _sortOrder = orders[newIndex];
    PreferenceUtils.setSortOrder(orders[newIndex]);
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
    if (completed) {
      _completedRecipes.add(key);
      PreferenceUtils.addCompletedRecipe(key);
    } else {
      _completedRecipes.remove(key);
      PreferenceUtils.removeCompletedRecipe(key);
    }
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

  List<Recipe> generateOptimizeList() {
    List<Recipe> buildableRecipe = [];
    List<Recipe> copyRecipe = List.from(getList());
    copyRecipe.removeWhere
      ((element) => element.ingredients.isEmpty
        || element.totalIngredients > optimizePotSize);
    // Sort by total ingredients with most first
    copyRecipe.sort((b, a) => a
        .totalIngredients
        .compareTo(b.totalIngredients));
    Map<String, int> copyIngredients =  Map.from(_userIngredients);
    for (var recipe in copyRecipe) {
      var amount = 99999;
      for (var ingredient in recipe.ingredients) {
        int multiply = (copyIngredients[ingredient.name] ?? 0) ~/ ingredient.quantity;
        if (multiply < amount) amount = multiply;
      }
      if (amount >= 0) {
        for (var ingredient in recipe.ingredients) {
          copyIngredients[ingredient.name] =
              (copyIngredients[ingredient.name] ?? 0) -
                  (ingredient.quantity * amount);
        }
        for (int i = 0; i < amount; i++) {
          buildableRecipe.add(recipe);
        }
      }
    }
    return buildableRecipe;
  }

  List<Recipe> generateCurrentList() {
    List<Recipe> selectedRecipe = getList();
    if (_filteredIngredients.isNotEmpty) {
      selectedRecipe = selectedRecipe
          .where((element) =>
              element.ingredients.isEmpty ||
              element.ingredients.every(
                  (element) => _filteredIngredients.contains(element.name)))
          .toList();
    }
    if (_bookmarkState != BookmarkState.all) {
      selectedRecipe = selectedRecipe.where((element) {
        bool isCompleted = _completedRecipes.contains(element.name);
        if (_bookmarkState == BookmarkState.yes) {
          return isCompleted;
        } else {
          return !isCompleted;
        }
      }).toList();
    }

    selectedRecipe.sort((b, a) => a
        .ingredientValue(_userIngredients)
        .compareTo(b.ingredientValue(_userIngredients)));

    if (_sortType == SortType.variety) {
      selectedRecipe.sort((a, b) => a
          .ingredients.length
          .compareTo(b.ingredients.length));
    } else if (_sortType == SortType.total) {
      selectedRecipe.sort((a, b) => a
          .totalIngredients
          .compareTo(b.totalIngredients));
    }

    if (_sortOrder == SortOrder.desc) {
      return selectedRecipe.reversed.toList();
    }

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

  void toggleBookmarkState() {
    List<BookmarkState> states = BookmarkState.values;
    int newIndex = (_bookmarkState.index + 1) % states.length;
    _bookmarkState = states[newIndex];
    PreferenceUtils.setBookmarkState(states[newIndex]);
    notifyListeners();
  }
}
