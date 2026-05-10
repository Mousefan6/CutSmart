import 'package:flutter/material.dart';
import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: bgColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Settings',
              style: TextStyle(color: AppTheme.accentColor.value, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Choose Color Palette",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentColor.value,
                ),
              ),
              const SizedBox(height: 20),

              // THE PALETTE SELECTOR ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _paletteCircle(ColorScene.classic, const Color(0xFF7D5334), "Classic"),
                  _paletteCircle(ColorScene.protanopia, const Color(0xFF005AB5), "Protan"),
                  _paletteCircle(ColorScene.deuteranopia, const Color(0xFFDAA520), "Deuter"),
                  _paletteCircle(ColorScene.night, const Color(0xFF424242), "Night"),

                ],
              ),

              const Spacer(),
              const BottomMenuBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _paletteCircle(ColorScene scene, Color previewColor, String label) {
    return GestureDetector(
      onTap: () => AppTheme.setTheme(scene),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: previewColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.currentScene == scene
                      ? Colors.black
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: AppTheme.accentColor.value, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
