import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipe.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/utils/constants.dart';

Future<Recipes?> scrapeRecipes() async {
  // URL of the website to scrape
  String actualUrl =
      '${Constants.bypassUrl}${Constants.serebiiBaseUrl}${Constants.serebiiDishesUrl}';
  // Fetch HTML content
  var response = await http.get(
    Uri.parse(actualUrl),
  );

  // Check if request was successful
  if (response.statusCode == 200) {
    // HTML content
    String html = response.body;
    var recipes = parseHtml(html);
    return recipes;
  } else {
    if (kDebugMode) {
      print("Failed");
    }
    return Recipes.empty();
  }
}

Future<List<Ingredient>> scrapeIngredients() async {
  // URL of the website to scrape
  String actualUrl =
      '${Constants.bypassUrl}${Constants.serebiiBaseUrl}${Constants.serebiiIngredientsUrl}';
  // Fetch HTML content
  var response = await http.get(
    Uri.parse(actualUrl),
  );
  // Check if request was successful
  if (response.statusCode == 200) {
    // HTML content
    String html = response.body;
    var result = parseIngredientsTable(html);
    return result;
  } else {
    if (kDebugMode) {
      print("Failed");
    }
    return [];
  }
}

Recipes parseHtml(String html) {
  // Scraping curry dishes
  var curryDishes = scrapeTableAt(2, html);
  // Scraping salad dishes
  var saladDishes = scrapeTableAt(3, html);
  // Scraping dessert dishes
  var dessertDishes = scrapeTableAt(4, html);

  return Recipes(
    curryDishes = curryDishes,
    saladDishes = saladDishes,
    dessertDishes = dessertDishes,
  );
}

List<Recipe> scrapeTableAt(int position, String html) {
  var document = parse(html);
  List<Recipe> recipes = [];
  var table = document.querySelectorAll('table')[position];
  table.querySelectorAll('tr').skip(1).forEach((row) {
    var columns = row.querySelectorAll('td');
    var picture = columns[0].querySelector('img')?.attributes['src']?.replaceAll("\\\"", "") ?? "";
    var name = columns[1].text.trim();
    var description = columns[2].text.trim();
    var ingredientsText = columns[3].text.trim();

    var ingredients = parseIngredients(ingredientsText);
    var recipe = {
      'picture': picture,
      'name': name,
      'description': description,
      'ingredients': ingredients,
    };

    recipes.add(Recipe.fromJson(recipe));
  });
  return recipes;
}

List<dynamic> parseIngredients(String ingredientsText) {
  var ingredients = [];
  // Split the string by each ingredient
  var parts = RegExp(r'[A-Za-z]+\s?[A-Za-z]*\s\*\s\d+')
      .allMatches(ingredientsText)
      .map((e) => e.group(0))
      .toList();

  // Iterate over each part and extract the ingredient name and quantity
  for (var part in parts) {
    var split = part?.split("*");
    var ingredientName = split?.first.trim();
    var quantity = int.tryParse(split?.last.trim() ?? '0');
    if (ingredientName != null && quantity != null) {
      var ingredientRecipe = {
        "name": ingredientName,
        "quantity": quantity,
      };
      ingredients.add(ingredientRecipe);
    }
  }

  return ingredients;
}

List<Ingredient> parseIngredientsTable(String html) {
  var document = parse(html);

  var ingredients = <Ingredient>[];

  var table = document.querySelectorAll('table')[2];
  // Skip the first row as it contains headers
  table.querySelectorAll('tr').skip(1).forEach((row) {
    var cells = row.querySelectorAll('td');

    var ingredient = {
      'picture': cells[0].querySelector('img')?.attributes['src']?.replaceAll("\\\"", "") ?? '',
      'name': cells[1].text.trim(),
      'description': cells[2].text.trim(),
      'baseStrength': int.tryParse(cells[3].text.trim()) ?? 0,
      'sellValue': cells[4].text.trim(),
    };

    ingredients.add(Ingredient.fromJson(ingredient));
  });

  return ingredients;
}
