import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:provider/provider.dart';

class RecipeIngredientsFilter extends StatelessWidget {

  const RecipeIngredientsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSetting>(builder: (context, userSetting, child) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          ...userSetting.ingredients.map(
            (element) => FilterChip(
              labelPadding: EdgeInsets.zero,
              shape: const CircleBorder(),
              showCheckmark: false,
              selected: userSetting.filteredIngredients.contains(element.name),
              onSelected: (isSelected) {
                if (isSelected) {
                  userSetting.addFilteredIngredient(element.name);
                } else {
                  userSetting.removeFilteredIngredient(element.name);
                }
              },
              label: Image.asset(
                element.pictureUrl,
                width: 40.0,
              ),
            ),
          ),
          ActionChip(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            label: const Text("Sync Ingr."),
            onPressed: () {
              userSetting.syncFilterIngredients();
            },
          ),
          ActionChip(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            label: const Text("Clear Ingr."),
            onPressed: () {
              userSetting.clearFilterIngredients();
            },
          )
        ],
      );
    });
  }
}
