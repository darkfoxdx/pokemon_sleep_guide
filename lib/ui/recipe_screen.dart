import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/ui/recipe_item.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class RecipeScreen extends StatefulWidget {
  final List<Ingredient> ingredients;
  final Recipes recipes;
  final Map<String, int> userIngredients;

  const RecipeScreen(this.ingredients, this.recipes, this.userIngredients,
      {super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late RecipeType recipeType;

  @override
  void initState() {
    super.initState();
    recipeType = PreferenceUtils.getRecipeType();
  }

  List<Recipe> getList(RecipeType recipeType) {
    switch (recipeType) {
      case RecipeType.curry:
        return widget.recipes.curryDishes;
      case RecipeType.salad:
        return widget.recipes.saladDishes;
      case RecipeType.dessert:
        return widget.recipes.dessertDishes;
    }
  }

  void selectRecipeType(bool selected, RecipeType input) {
    setState(() {
      recipeType = selected ? input : RecipeType.curry;
      PreferenceUtils.setRecipeType(recipeType);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> selectedRecipe = getList(recipeType);
    selectedRecipe.sort((b, a) => a
        .ingredientValue(widget.userIngredients)
        .compareTo(b.ingredientValue(widget.userIngredients)));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Curry'),
                selected: recipeType == RecipeType.curry,
                onSelected: (bool selected) {
                  selectRecipeType(selected, RecipeType.curry);
                },
              ),
              const SizedBox(width: 8.0),
              ChoiceChip(
                label: const Text('Salad'),
                selected: recipeType == RecipeType.salad,
                onSelected: (bool selected) {
                  selectRecipeType(selected, RecipeType.salad);
                },
              ),
              const SizedBox(width: 8.0),
              ChoiceChip(
                label: const Text('Dessert'),
                selected: recipeType == RecipeType.dessert,
                onSelected: (bool selected) {
                  selectRecipeType(selected, RecipeType.dessert);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedRecipe.length,
            itemBuilder: (context, index) {
              Recipe recipe = selectedRecipe[index];
              return RecipeItem(
                recipe,
                widget.ingredients,
                widget.userIngredients,
              );
            },
          ),
        ),
      ],
    );
  }
}
