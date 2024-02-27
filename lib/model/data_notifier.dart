import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/data.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/utils/json_utils.dart';

class DataNotifier extends ChangeNotifier {
  Recipes _recipes = Recipes.empty();
  final List<Ingredient> _ingredients = [];

  Recipes get recipes => _recipes;

  UnmodifiableListView<Ingredient> get ingredients =>
      UnmodifiableListView(_ingredients);

  Data get data => Data(_recipes, _ingredients);

  Future<void> _initRecipes(BuildContext context) async {
    _recipes = await fetchRecipes(context);
  }

  Future<void> _initIngredients(BuildContext context) async {
    final list = await fetchIngredients(context);
    _ingredients.addAll(list);
  }

  Future<void> init(BuildContext context) async {
    await [_initRecipes(context), _initIngredients(context)].wait;
    notifyListeners();
  }
}
