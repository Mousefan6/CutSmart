import 'package:flutter/material.dart';

class AppTheme {
  // Our global variable for the current background color
  static ValueNotifier<Color> backgroundColor = ValueNotifier(const Color(0xFFE3D8CD));
  static ValueNotifier<Color> accentColor = ValueNotifier(const Color(0xFF7D5334));

  static void toggleTheme() {
    if (backgroundColor.value == const Color(0xFFE3D8CD)) {
      // Switch to a "Dark" or "Alternative" mode
      backgroundColor.value = const Color(0xFF2D2D2D);
      accentColor.value = const Color(0xFFF5EBE0);
    } else {
      // Switch back to "Classic Tan"
      backgroundColor.value = const Color(0xFFE3D8CD);
      accentColor.value = const Color(0xFF7D5334);
    }
  }
}
