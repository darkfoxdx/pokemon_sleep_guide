import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:provider/provider.dart';

class IngredientItem extends StatefulWidget {
  const IngredientItem(
    this.ingredient, {
    super.key,
    this.quantity = 0,
  });

  final Ingredient ingredient;
  final int quantity;

  @override
  State<IngredientItem> createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientItem> {
  int currentQuantity = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentQuantity = widget.quantity;
  }

  void increaseCurrentQuantity() {
    currentQuantity = currentQuantity + 1;
    Provider.of<UserSetting>(context, listen: false)
        .setIngredient(widget.ingredient.name, currentQuantity);
  }

  void decreaseCurrentQuantity() {
    currentQuantity = currentQuantity - 1;
    Provider.of<UserSetting>(context, listen: false)
        .setIngredient(widget.ingredient.name, currentQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            increaseCurrentQuantity();
          },
          onTapDown: (TapDownDetails details) {
            _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
              increaseCurrentQuantity();
            });
          },
          onTapUp: (TapUpDetails details) {
            _timer?.cancel();
          },
          onTapCancel: () {
            _timer?.cancel();
          },
          customBorder: const CircleBorder(),
          child: Ink(
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(widget.ingredient.pictureUrl),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Card(
            color: Colors.white,
            child: SizedBox(
              height: 20,
              width: 45,
              child: Center(
                child: Text(
                  "×$currentQuantity",
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: currentQuantity > 0,
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                decreaseCurrentQuantity();
              },
              onTapDown: (TapDownDetails details) {
                _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
                  decreaseCurrentQuantity();
                });
              },
              onTapUp: (TapUpDetails details) {
                _timer?.cancel();
              },
              onTapCancel: () {
                _timer?.cancel();
              },
              child: const Card(
                color: Colors.white,
                shape: CircleBorder(),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: Text(
                      "−",
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
