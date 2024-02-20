import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipe_status.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_list.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final List<Ingredient> ingredients;
  final Map<String, int> userIngredients;

  const RecipeItem(this.recipe, this.ingredients, this.userIngredients,
      {super.key});

  @override
  Widget build(BuildContext context) {
    RecipeStatus recipeStatus = recipe.ingredientStatus(userIngredients);
    Color? cardTintColor;
    switch(recipeStatus) {
      case RecipeStatus.completed:
        cardTintColor = Theme.of(context).colorScheme.completed;
      case RecipeStatus.partial:
        cardTintColor = Theme.of(context).colorScheme.partial;
      case RecipeStatus.none:
        cardTintColor = null;
    }

    return Card(
      color: Theme.of(context).cardColor,
      surfaceTintColor: cardTintColor,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Image.asset(recipe.pictureUrl),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name.toString(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ingr.:"),
                      Expanded(
                        child: IngredientList(
                          recipe.ingredients,
                          userIngredients,
                          ingredients,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
