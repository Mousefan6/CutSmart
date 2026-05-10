import 'package:cutsmart/App/Scenes/history_page.dart';
import 'package:cutsmart/App/Scenes/login_page.dart';
import 'package:cutsmart/App/Scenes/profile_page.dart';
import 'package:flutter/material.dart';
import '../Scenes/camera_page.dart';
import '../Scenes/register_page.dart';
import '../Scenes/settings_page.dart';
import '../Scenes/video_page.dart';
import '../UI/app_theme.dart'; // Ensure this points to your theme file

class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // Now follows the accent color of your selected palette
              color: AppTheme.accentColor.value,
          ),
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _menuButton(
                context,
                icon: Icons.person_outline,
                label: "Profile",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
              ), // TO ADD: BRING USER TO THEIR PROFILE PAGE AND MAKE PROFILE PAGE IF LOGGED IN

              _menuButton(
                context,
                icon: Icons.document_scanner_outlined,
                label: "Scanner",
                isLarge: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraPage())),
              ),
              _menuButton(
                context,
                icon: Icons.history,
                isLarge: true,
                label: "History",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
              ),

              _menuButton(
                context,
                icon: Icons.settings_outlined, // Fixed icon
                label: "Settings",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        bool isLarge = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isLarge ? 22 : 14),
            decoration: BoxDecoration(
              // The button background now matches your theme's card color
              color: AppTheme.cardColor.value,
              borderRadius: BorderRadius.circular(isLarge ? 20 : 16),
              boxShadow: isLarge
                  ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Icon(
              icon,
              size: isLarge ? 32 : 24,
              // The icon color matches the background color for a "cut out" look
              color: AppTheme.accentColor.value,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              // Label color matches the card color for contrast against the bar
              color: AppTheme.cardColor.value,
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
