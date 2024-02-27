
import 'package:flutter/material.dart';

class FilterNotifier extends ChangeNotifier {
  bool _showFilter = false;

  bool get showFilter => _showFilter;

  void toggleShowFilter() {
    _showFilter = !_showFilter;
    notifyListeners();
  }
}
