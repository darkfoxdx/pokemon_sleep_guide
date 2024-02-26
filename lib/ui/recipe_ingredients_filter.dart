import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:provider/provider.dart';

class RecipeIngredientsFilter extends StatelessWidget {
  final List<Ingredient> ingredients;

  const RecipeIngredientsFilter(this.ingredients, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSetting>(builder: (context, userSetting, child) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          ...ingredients.map(
            (element) => FilterChip(
              labelPadding: EdgeInsets.zero,
              shape: const CircleBorder(),
              showCheckmark: false,
              selected:
                  !userSetting.filteredOutIngredients.contains(element.name),
              onSelected: (isSelected) {
                if (isSelected) {
                  userSetting.removeFilteredOutIngredient(element.name);
                } else {
                  userSetting.addFilteredOutIngredient(element.name);
                }
              },
              label: Image.asset(
                element.pictureUrl,
                width: 40.0,
              ),
            ),
          ),
          ActionChip(
            label: const Text("Sync ingredients filter"),
            onPressed: () {
              userSetting.syncFilterOutIngredients(ingredients);
            },
          )
        ],
      );
    });
  }
}
