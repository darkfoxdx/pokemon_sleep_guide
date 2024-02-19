import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_guide/utils/preference_utils.dart';

class UserSetting extends ChangeNotifier {
  final Map<String, int> _ingredients = {};

  UnmodifiableMapView<String, int> get ingredients =>
      UnmodifiableMapView(_ingredients);

  UserSetting(Map<String, int> ingredients) {
    _ingredients.addAll(ingredients);
  }

  void setIngredient(String key, int quality) {
    _ingredients[key] = quality;
    PreferenceUtils.setIngredient(key, quality);
    notifyListeners();
  }
}
