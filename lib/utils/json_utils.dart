import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';

Future<Recipes> fetchRecipes(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString(
      "jsons/recipes.json");
  final Map jsonResult = jsonDecode(data);
  final List curryList = jsonResult['curryDishes'];
  final List saladList = jsonResult['saladDishes'];
  final List dessertList = jsonResult['dessertDishes'];

  return Recipes(
    curryList.map((e) => Recipe.fromJson(e)).toList(),
    saladList.map((e) => Recipe.fromJson(e)).toList(),
    dessertList.map((e) => Recipe.fromJson(e)).toList(),
  );
}

Future<List<Ingredient>> fetchIngredients(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString(
      "jsons/ingredients.json");
  final List jsonResult = jsonDecode(data);

  return jsonResult.map((e) => Ingredient.fromJson(e)).toList();

}