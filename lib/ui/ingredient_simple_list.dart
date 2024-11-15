import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe_ingredient.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';

class IngredientSimpleList extends StatelessWidget {
  final List<RecipeIngredient> recipeIngredients;
  final List<Ingredient> ingredients;

  const IngredientSimpleList(
      this.recipeIngredients, this.ingredients,
      {super.key});

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> list = [];
    if (recipeIngredients.isEmpty) {
      return [
        Text(
          "  Any",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.completed,
              ),
        )
      ];
    }
    for (final e in recipeIngredients) {
      String? picture = ingredients
          .firstWhere((element) => element.name == e.name,
              orElse: Ingredient.empty)
          .pictureUrl;
      int quantity = e.quantity;
      Widget widget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 4.0),
            child: Image.asset(
              picture,
              width: 24,
            ),
          ),
          Text(
            "$quantity",
          ),
        ],
      );
      list.add(widget);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: _buildItems(context),
    );
  }
}
