import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_screen.dart';
import 'package:pokemon_sleep_guide/utils/scraper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _buildScreen(int index, List<Ingredient> ingredients) {
    return <Widget>[
      IngredientScreen(ingredients),
      const Text(
        'Index 1: Recipes',
        style: optionStyle,
      ),
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
            future: Future.wait([scrapeIngredients()]),
            builder: (context, snapshot) {
              return Center(
                child: _buildScreen(_selectedIndex, snapshot.data?[0] ?? []),
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
