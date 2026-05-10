import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Utils/session_manager.dart';

enum ColorScene {
  classic,
  protanopia,
  deuteranopia,
  night
}

class AppTheme {

  // UI listeners
  static ValueNotifier<Color> backgroundColor =
  ValueNotifier(
    const Color(0xFFE3D8CD),
  );

  static ValueNotifier<Color> accentColor =
  ValueNotifier(
    const Color(0xFFB08968),
  );

  static ValueNotifier<Color> cardColor =
  ValueNotifier(
    Colors.white,
  );

  static ColorScene currentScene =
      ColorScene.classic;

  static Future<void> setTheme(
      ColorScene scene,
      ) async {

    currentScene = scene;

    switch (scene) {
      case ColorScene.protanopia:
        backgroundColor.value =
        const Color(0xFFE8E8E8);
        accentColor.value =
        const Color(0xFF005AB5);
        cardColor.value =
            Colors.white;
        break;

      case ColorScene.deuteranopia:
        backgroundColor.value =
        const Color(0xFFFFE0B2);
        accentColor.value =
        const Color(0xFFDAA520);
        cardColor.value =
            Colors.white;
        break;

      case ColorScene.classic:
        backgroundColor.value =
        const Color(0xFFE3D8CD);
        accentColor.value =
        const Color(0xFFB08968);
        cardColor.value =
            Colors.white;
        break;

      case ColorScene.night:
        backgroundColor.value =
        const Color(0xFF263238);
        accentColor.value =
        const Color(0xFFD6D6D6);
        cardColor.value =
        const Color(0xFF424242);
        break;
    }
    await _saveThemeToDatabase(scene.name);
  }

  // SAVE THEME TO MONGODB THROUGH FLASK
  static Future<void> _saveThemeToDatabase(
      String theme,
      ) async {
    try {
      final token =
      await SessionManager.instance.getToken();

      if (token == null) return;

      final response = await http.post(
        Uri.parse(
          "http://10.0.2.2:5000/profile/theme",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "theme": theme,
        }),
      );
      print(
        "Theme save status: ${response.statusCode}",
      );
    } catch (e) {
      print("Theme save error: $e");
    }
  }
}
