import 'package:flutter/material.dart';

enum ColorScene { classic, protanopia, deuteranopia, night }

class AppTheme {
  // Notifiers for the UI to listen to
  static ValueNotifier<Color> backgroundColor = ValueNotifier(const Color(0xFFE3D8CD));
  static ValueNotifier<Color> accentColor = ValueNotifier(const Color(0xFF7D5334));
  static ValueNotifier<Color> cardColor = ValueNotifier(Colors.white);

  static ColorScene currentScene = ColorScene.classic;

  static void setTheme(ColorScene scene) {
    currentScene = scene;
    switch (scene) {
      case ColorScene.protanopia:
        backgroundColor.value = const Color(0xFFE8E8E8);
        accentColor.value = const Color(0xFF005AB5); // High contrast blue
        cardColor.value = Colors.white;
        break;
      case ColorScene.deuteranopia:
        backgroundColor.value = const Color(0xFFFFE0B2);
        accentColor.value = const Color(0xFFDAA520); // Goldenrod for visibility
        cardColor.value = Colors.white;
        break;
      case ColorScene.classic:
        backgroundColor.value = const Color(0xFFE3D8CD);
        accentColor.value = const Color(0xFF7D5334);
        cardColor.value = Colors.white;
        break;
      case ColorScene.night:
        backgroundColor.value = const Color(0xFF263238);
        accentColor.value = const Color(0xFFD6D6D6);
        cardColor.value = const Color(0xFF424242);
      break;
    }
  }
}
