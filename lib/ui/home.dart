import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/tab_notifier.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_screen.dart';
import 'package:pokemon_sleep_guide/ui/optimize_screen.dart';
import 'package:pokemon_sleep_guide/ui/recipe_screen.dart';
import 'package:pokemon_sleep_guide/ui/setting_screen.dart';
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
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
            child: Image.asset('assets/icon.png'),
          ),
          title: const Text('Pokemon Sleep'),
        ),
        body: Center(
          child: Consumer<TabNotifier>(builder: (context, tab, child) {
            return IndexedStack(
              index: tab.selectedIndex,
              children: const [
                IngredientScreen(),
                RecipeScreen(),
                OptimizeScreen(),
                SettingScreen(),
              ],
            );
          }),
        ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Optimize',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
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
