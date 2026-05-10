import 'package:flutter/material.dart';
import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart'; // Import your new theme file

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.accentColor.value),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'CutSmart',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentColor.value,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'User Settings',
                        style: TextStyle(
                          color: AppTheme.accentColor.value,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // NEW THEME TOGGLE BUTTON
                      ElevatedButton.icon(
                        onPressed: () => AppTheme.toggleTheme(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor.value,
                          foregroundColor: bgColor,
                        ),
                        icon: const Icon(Icons.palette_outlined),
                        label: const Text("CHANGE THEME"),
                      ),
                    ],
                  ),
                ),
              ),
              const BottomMenuBar(),
            ],
          ),
        );
      },
    );
  }
}
