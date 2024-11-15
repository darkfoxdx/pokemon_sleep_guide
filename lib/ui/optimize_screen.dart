import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/recipe_simple_item.dart';
import 'package:pokemon_sleep_guide/utils/constants.dart';
import 'package:provider/provider.dart';

class OptimizeScreen extends StatelessWidget {
  const OptimizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<UserSetting>(builder: (context, userSetting, child) {
            List<Recipe> currentList = userSetting.generateOptimizeList();
            int ingredientsHave = userSetting.userIngredients.values
                .fold(0, (previousValue, element) => previousValue + element);
            int ingredientsUsed = currentList.fold(
                0,
                (previousValue, element) =>
                    previousValue + element.totalIngredients);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0),
                              child:
                                  Text("$ingredientsUsed out of $ingredientsHave used"),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0),
                              child: Text("${currentList.length} recipes possible"),
                            ),
                          ),
                        ],
                      ),
                      DropdownMenu<int>(
                        initialSelection: userSetting.optimizePotSize,
                        label: const Text('Pot size'),
                        requestFocusOnTap: false,
                        onSelected: (int? size) {
                          if (size != null) {
                            userSetting.setOptimizePotSize(size);
                          }
                        },
                        dropdownMenuEntries: Constants.potSize
                            .map<DropdownMenuEntry<int>>(
                                (int size) {
                              return DropdownMenuEntry<int>(
                                value: size,
                                label: size.toString(),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = currentList[index];
                      return RecipeSimpleItem(
                        recipe,
                        userSetting.ingredients,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
