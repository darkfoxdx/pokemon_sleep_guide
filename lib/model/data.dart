import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';

class Data {
  final Recipes recipes;
  final List<Ingredient> ingredients;

  Data(this.recipes, this.ingredients);

  Data.empty()
      : recipes = Recipes.empty(),
        ingredients = [];

  @override
  String toString() {
    return {
      "recipes": recipes.toString(),
      "ingredients": ingredients.toString(),
    }.toString();
  }
}
