import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/data_notifier.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/recipes.dart';
import 'package:pokemon_sleep_guide/model/tab_notifier.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_screen.dart';
import 'package:pokemon_sleep_guide/ui/recipe_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _onItemTapped(BuildContext context, int index) {
    Provider.of<TabNotifier>(context, listen: false).setTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon Sleep'),
        ),
        body: Consumer<DataNotifier>(builder: (context, data, child) {
          List<Ingredient> ingredients = data.ingredients;
          Recipes recipes = data.recipes;
          return Center(
            child: Consumer<TabNotifier>(builder: (context, tab, child) {
              return IndexedStack(
                index: tab.selectedIndex,
                children: [
                  IngredientScreen(ingredients),
                  RecipeScreen(ingredients, recipes),
                ],
              );
            }),
          );
        }),
        bottomNavigationBar:
            Consumer<TabNotifier>(builder: (context, tab, child) {
          return BottomNavigationBar(
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
            currentIndex: tab.selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) => _onItemTapped(context, index),
          );
        }),
      ),
    );
  }
}
