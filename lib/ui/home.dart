import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_screen.dart';
import 'package:pokemon_sleep_guide/ui/recipe_screen.dart';
import 'package:pokemon_sleep_guide/utils/json_utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  Widget _buildScreen(
      int index, List<Ingredient> ingredients, Recipes recipes) {
    return <Widget>[
      IngredientScreen(ingredients),
      RecipeScreen(ingredients, recipes),
    ][index];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon Sleep'),
        ),
        body: FutureBuilder(
            future: (fetchIngredients(context), fetchRecipes(context)).wait,
            builder: (context, snapshot) {
              List<Ingredient> ingredients = snapshot.data?.$1 ?? [];
              Recipes recipes = snapshot.data?.$2 ?? Recipes.empty();
              return Center(
                child: _buildScreen(_selectedIndex, ingredients, recipes),
              );
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.egg),
              label: 'Ingredients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Recipes',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}