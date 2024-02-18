import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_item.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class IngredientScreen extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientScreen(this.ingredients, {super.key});

  @override
  Widget build(BuildContext context) {
    var userIngredients = PreferenceUtils.getUserIngredients();

    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 4,
      children: ingredients.map((e) {
        int quantity = userIngredients[e.name] ?? 0;
        return IngredientItem(
          e,
          quantity: quantity,
        );
      }).toList(),
    );
  }
}
