import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/filter_notifier.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/bookmark_filter.dart';
import 'package:pokemon_sleep_guide/ui/recipe_ingredients_filter.dart';
import 'package:pokemon_sleep_guide/ui/recipe_item.dart';
import 'package:pokemon_sleep_guide/ui/recipe_tabs.dart';
import 'package:pokemon_sleep_guide/ui/sort_tool.dart';
import 'package:provider/provider.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: RecipeTabs(),
        ),
        Visibility(
          visible: Provider.of<FilterNotifier>(context).showFilter,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RecipeIngredientsFilter(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: BookmarkFilter(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: SortTool(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Consumer<UserSetting>(builder: (context, userSetting, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${userSetting.currentListLength}/${userSetting.recipeListLength}"),
                Consumer<FilterNotifier>(builder: (context, filter, child) {
                  return IconButton(
                    onPressed: () {
                      filter.toggleShowFilter();
                    },
                    tooltip: "Show filter",
                    isSelected: filter.showFilter,
                    icon: const Icon(Icons.filter_alt_outlined),
                    selectedIcon: const Icon(Icons.filter_alt),
                  );
                }),
              ],
            );
          }),
        ),
        Expanded(
          child: Consumer<UserSetting>(builder: (context, userSetting, child) {
            List<Recipe> currentList = userSetting.generateCurrentList();
            return ListView.builder(
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                Recipe recipe = currentList[index];
                return RecipeItem(
                  recipe,
                  userSetting.ingredients,
                  userSetting.userIngredients,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
