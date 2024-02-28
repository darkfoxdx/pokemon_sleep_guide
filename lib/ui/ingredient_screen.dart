import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/ui/ingredient_item.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';
import 'package:provider/provider.dart';

class IngredientScreen extends StatelessWidget {
  const IngredientScreen({super.key});

  Future<void> _showConfirmationDialog(BuildContext context,
      {Function()? onClick}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear all ingredients'),
          content: const Text(
              'Are you sure you would like to clear all ingredients amount?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.redSecondary,
              ),
              onPressed: () {
                onClick?.call();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Consumer<UserSetting>(builder: (context, userSetting, child) {
            return FilledButton.icon(
              onPressed: userSetting.userIngredients.isNotEmpty
                  ? () => _showConfirmationDialog(
                        context,
                        onClick: () {
                          userSetting.clearIngredients();
                        },
                      )
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.redPrimary,
                foregroundColor: Theme.of(context).colorScheme.white,
              ),
              icon: const Icon(Icons.clear),
              label: const Text("Clear All"),
            );
          }),
        ),
        Expanded(
          child: Consumer<UserSetting>(
            builder: (context, userSetting, child) {
              return GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 4,
                children: userSetting.ingredients.map((e) {
                  int quantity = userSetting.userIngredients[e.name] ?? 0;
                  return IngredientItem(
                    e,
                    quantity: quantity,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
