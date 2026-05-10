import 'package:flutter/material.dart';
import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart';

import '../Utils/session_manager.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionManager.instance.isLoggedIn(), // FOR ACTUAL PROFILE PAGE
      builder: (context, snapshot) {
        // While waiting for the async check
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If NOT logged in, show the Login Page instead
        if (snapshot.data == false) {
          return const LoginPage();
        }

        // If logged in, show the normal Settings UI
        return _buildSettingsUI(context);
      },
    );
  }

  Widget _buildSettingsUI(BuildContext context) {
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

              // LOGOUT BUTTON
              const SizedBox(height: 60), // Space between palette and logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.redAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    print("Logout pressed"); // EDIT FOR LOGOUT BUTTON
                  },
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
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
