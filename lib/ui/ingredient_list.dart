import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe_ingredient.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';

class IngredientList extends StatelessWidget {
  final List<RecipeIngredient> recipeIngredients;
  final Map<String, int> userIngredients;
  final List<Ingredient> ingredients;

  const IngredientList(
      this.recipeIngredients, this.userIngredients, this.ingredients,
      {super.key});

  List<InlineSpan> _buildSpan(BuildContext context) {
    List<InlineSpan> list = [];
    if (recipeIngredients.isEmpty) {
      return [
        TextSpan(
          text: "  Any",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.completed,
              ),
        )
      ];
    }
    for (final (i, e) in recipeIngredients.indexed) {
      if (i == 2) {
        list.add(const TextSpan(text: "\n"));
      }
      String? picture = ingredients
          .firstWhere((element) => element.name == e.name,
              orElse: Ingredient.empty)
          .pictureUrl;
      int userQuantity = userIngredients[e.name] ?? 0;
      int quantity = e.quantity;
      var imageSpan = WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 4.0),
          child: Image.asset(
            picture,
            width: 24,
          ),
        ),
      );
      var textSpan = TextSpan(
        text: "$userQuantity / $quantity",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: userQuantity >= quantity
                  ? Theme.of(context).colorScheme.completed
                  : null,
            ),
      );
      list.addAll([imageSpan, textSpan]);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 10,
      softWrap: true,
      text: TextSpan(
        children: _buildSpan(context),
      ),
    );
  }
}
