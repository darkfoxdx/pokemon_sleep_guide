import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get completed => brightness == Brightness.light
      ? const Color(0xFF28a745)
      : const Color(0xFF28a745);

  Color get made => brightness == Brightness.light
      ? const Color(0xFF009900)
      : const Color(0xFF33CC33);

  Color get partial => brightness == Brightness.light
      ? const Color(0xFFB89E13)
      : const Color(0xFFB89E13);

  Color get redPrimary => brightness == Brightness.light
      ? const Color(0xFFB22222)
      : const Color(0xFF8B0000);

  Color get redSecondary => brightness == Brightness.light
      ? const Color(0xFF8B0000)
      : const Color(0xFFFF7F7F);

  Color get white => const Color(0xFFF5F5F5);
}
