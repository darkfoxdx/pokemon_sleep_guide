import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/recipe_ingredients_filter.dart';
import 'package:pokemon_sleep_guide/ui/recipe_item.dart';
import 'package:pokemon_sleep_guide/ui/recipe_tabs.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  Map<String, int> _generateIngredientRecipeCount(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: RecipeTabs(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: RecipeIngredientsFilter(),
        ),
        Expanded(
          child: Consumer<UserSetting>(
            builder: (context, userSetting, child) {
              List<Recipe> selectedRecipe = userSetting.generateCurrentList();
              return ListView.builder(
                itemCount: selectedRecipe.length,
                itemBuilder: (context, index) {
                  Recipe recipe = selectedRecipe[index];
                  return RecipeItem(
                    recipe,
                    userSetting.ingredients,
                    userSetting.userIngredients,
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}
