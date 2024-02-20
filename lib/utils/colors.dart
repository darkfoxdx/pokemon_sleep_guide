import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get completed => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0xFF28a745);

  Color get made => brightness == Brightness.light
      ? const Color(0xFFA5D6A7)
      : const Color(0xFF1B5E20);

  Color get partial => brightness == Brightness.light
      ? const Color(0xFFB89E13)
      : const Color(0xFFB89E13);
}
