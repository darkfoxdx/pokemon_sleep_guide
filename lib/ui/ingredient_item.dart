import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/model/ingredient.dart';
import 'package:pokemon_sleep_guide/model/user_setting.dart';
import 'package:pokemon_sleep_guide/utils/colors.dart';
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
  Timer? _timer;

  void increaseCurrentQuantity() {
    Provider.of<UserSetting>(context, listen: false)
        .setIngredient(widget.ingredient.name, widget.quantity + 1);
  }

  void decreaseCurrentQuantity() {
    Provider.of<UserSetting>(context, listen: false)
        .setIngredient(widget.ingredient.name, widget.quantity - 1);
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
            color: Theme.of(context).colorScheme.white,
            child: SizedBox(
              height: 20,
              width: 45,
              child: Center(
                child: Text(
                  "×${widget.quantity}",
                  style: TextStyle(
                    color: widget.quantity == 0
                        ? Theme.of(context).colorScheme.redPrimary
                        : Colors.grey[900],
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.quantity > 0,
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
              child: Card(
                color: Theme.of(context).colorScheme.white,
                shape: const CircleBorder(),
                child: const SizedBox(
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
