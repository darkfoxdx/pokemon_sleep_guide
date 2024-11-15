import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_simple_list.dart';

class RecipeSimpleItem extends StatelessWidget {
  final Recipe recipe;
  final List<Ingredient> ingredients;

  const RecipeSimpleItem(this.recipe, this.ingredients,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Image.asset(recipe.pictureUrl),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${recipe.name} (${recipe.totalIngredients})',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ingr.:'),
                        Expanded(
                          child: IngredientSimpleList(
                            recipe.ingredients,
                            ingredients,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}