import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/recipe_ingredients_filter.dart';
import 'package:pokemon_sleep_guide/ui/recipe_item.dart';
import 'package:pokemon_sleep_guide/ui/recipe_tabs.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatelessWidget {
  final List<Ingredient> ingredients;
  final Recipes recipes;

  const RecipeScreen(this.ingredients, this.recipes, {super.key});

  List<Recipe> getList(RecipeType recipeType) {
    switch (recipeType) {
      case RecipeType.curry:
        return recipes.curryDishes;
      case RecipeType.salad:
        return recipes.saladDishes;
      case RecipeType.dessert:
        return recipes.dessertDishes;
    }
  }

  List<Recipe> _generateCurrentList(BuildContext context, RecipeType recipeType,
      Map<String, int> userIngredients, List<String> filteredOutIngredients) {
    List<Recipe> selectedRecipe = getList(recipeType)
        .where((element) =>
            element.ingredients.isEmpty ||
            element.ingredients.every(
                (element) => !filteredOutIngredients.contains(element.name)))
        .toList();
    selectedRecipe.sort((b, a) => a
        .ingredientValue(userIngredients)
        .compareTo(b.ingredientValue(userIngredients)));
    return selectedRecipe;
  }

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
    final Map<String, int> userIngredients =
        Provider.of<UserSetting>(context).userIngredients;
    final RecipeType recipeType = Provider.of<UserSetting>(context).recipeType;
    final List<String> filteredOutIngredients =
        Provider.of<UserSetting>(context).filteredOutIngredients;

    List<Recipe> selectedRecipe = _generateCurrentList(
        context, recipeType, userIngredients, filteredOutIngredients);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: RecipeTabs(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RecipeIngredientsFilter(ingredients),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedRecipe.length,
            itemBuilder: (context, index) {
              Recipe recipe = selectedRecipe[index];
              return RecipeItem(
                recipe,
                ingredients,
                userIngredients,
              );
            },
          ),
        ),
      ],
    );
  }
}
