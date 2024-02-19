import 'package:path/path.dart';
import 'package:pokemon_sleep_guide/model/recipe_ingredient.dart';

class Recipe {
  final String picture;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;

  Recipe(this.picture, this.name, this.description, this.ingredients);

  String get pictureUrl => "images/${basename(picture)}";

  int ingredientValue(Map<String, int> userIngredient) {
    List<int> exceeded = [0];
    for (final ingredient in ingredients) {
      if ((userIngredient[ingredient.name] ?? 0) >= ingredient.quantity) {
        exceeded.add(1);
      }
    }

    int sum = exceeded.reduce((a, b) => a + b);
    return sum == ingredients.length ? sum + 10 : sum;
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
