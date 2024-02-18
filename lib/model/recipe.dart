import 'package:pokemon_sleep_guide/model/recipe_ingredient.dart';

class Recipe {
  final String picture;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;

  Recipe(this.picture, this.name, this.description, this.ingredients);

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
