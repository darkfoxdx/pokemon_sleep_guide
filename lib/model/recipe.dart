import 'package:path/path.dart';
import 'package:pokemon_sleep_guide/model/recipe_ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe_status.dart';

class Recipe {
  final String picture;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;

  Recipe(this.picture, this.name, this.description, this.ingredients);

  String get pictureUrl => "images/${basename(picture)}";

  List<String> get uniqueIngredients => ingredients.map((e) => e.name).toList();

  int get totalIngredients => ingredients.fold(
      0, (previousValue, element) => previousValue + element.quantity);

  double noOfCompletedIngredients(Map<String, int> userIngredient) {
    List<double> exceeded = [0];
    for (final ingredient in ingredients) {
      int quantity = userIngredient[ingredient.name] ?? 0;
      if (quantity >= ingredient.quantity) {
        exceeded.add(1);
      } else if (quantity > 0) {
        exceeded.add(0.5);
      }
    }
    double sum = exceeded.reduce((a, b) => a + b);
    return sum;
  }

  RecipeStatus ingredientStatus(Map<String, int> userIngredient) {
    double sum = noOfCompletedIngredients(userIngredient);
    if (sum == ingredients.length) {
      return RecipeStatus.completed;
    } else if (sum != 0) {
      return RecipeStatus.partial;
    }
    return RecipeStatus.none;
  }

  double ingredientValue(Map<String, int> userIngredient) {
    RecipeStatus status = ingredientStatus(userIngredient);
    double sum = noOfCompletedIngredients(userIngredient);
    switch (status) {
      case RecipeStatus.completed:
        return sum + 10;
      case RecipeStatus.partial:
        return sum + 5;
      case RecipeStatus.none:
        return sum;
    }
  }

  Recipe.fromJson(Map<String, dynamic> json)
      : picture = json['picture'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        ingredients = (json['ingredients'] as List)
            .map((e) => RecipeIngredient.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'picture': picture,
        'name': name,
        'description': description,
        'ingredients': ingredients.map((e) => e.toJson()),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
