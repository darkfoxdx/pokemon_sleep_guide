import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get enough => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0xFF28a745);
}
