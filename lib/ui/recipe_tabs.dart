import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/recipe_type.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:provider/provider.dart';

class RecipeTabs extends StatelessWidget {
  const RecipeTabs({super.key});

  void _selectRecipeType(BuildContext context, bool selected, RecipeType input) {
    final recipeType = selected ? input : RecipeType.curry;
    Provider.of<UserSetting>(context, listen: false).setRecipeType(recipeType);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSetting>(
        builder: (context, userSetting, child) {
          return Row(
            children: [
              ChoiceChip(
                label: const Text('Curry'),
                showCheckmark: false,
                selected: userSetting.recipeType == RecipeType.curry,
                onSelected: (bool selected) {
                  _selectRecipeType(context, selected, RecipeType.curry);
                },
              ),
              const SizedBox(width: 8.0),
              ChoiceChip(
                label: const Text('Salad'),
                showCheckmark: false,
                selected: userSetting.recipeType == RecipeType.salad,
                onSelected: (bool selected) {
                  _selectRecipeType(context, selected, RecipeType.salad);
                },
              ),
              const SizedBox(width: 8.0),
              ChoiceChip(
                label: const Text('Dessert'),
                showCheckmark: false,
                selected: userSetting.recipeType == RecipeType.dessert,
                onSelected: (bool selected) {
                  _selectRecipeType(context, selected, RecipeType.dessert);
                },
              ),
            ],
          );
        }
    );
  }
}
