import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart'; // Ensure this points to your theme file

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the global background color change
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
              // Back arrow now follows the theme accent
              icon: Icon(Icons.arrow_back, color: AppTheme.accentColor.value),
              onPressed: () => Navigator.pop(context),
            ),
            title: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
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
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Icon follows the theme
                      Icon(
                        Icons.account_circle,
                        size: 100,
                        color: AppTheme.accentColor.value.withOpacity(0.8),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'User Profile',
                        style: TextStyle(
                          color: AppTheme.accentColor.value,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // The custom menu bar
              const BottomMenuBar(),
            ],
          ),
        );
      },
    );
  }
}
