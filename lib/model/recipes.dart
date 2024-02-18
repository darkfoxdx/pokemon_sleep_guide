import 'package:pokemon_sleep_guide/model/recipe.dart';

class Recipes {
  final List<Recipe> curryDishes;
  final List<Recipe> saladDishes;
  final List<Recipe> dessertDishes;

  Recipes(this.curryDishes, this.saladDishes, this.dessertDishes);

  Recipes.empty()
      : curryDishes = [],
        saladDishes = [],
        dessertDishes = [];

  @override
  String toString() {
    return {
      "curryDishes": curryDishes,
      "saladDishes": saladDishes,
      "dessertDishes": dessertDishes,
    }.toString();
  }
}
