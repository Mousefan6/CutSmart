import 'package:cutsmart/App/Scenes/login_page.dart';
import 'package:flutter/material.dart';
import '../Scenes/video_page.dart';
import '../Scenes/camera_page.dart';
import '../Scenes/login_page.dart';
import '../Scenes/settings_page.dart';
import '../Scenes/saved_page.dart';



class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFB08968),
      ),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 40), // Slightly adjusted padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Better spacing for mixed sizes
        crossAxisAlignment: CrossAxisAlignment.end,      // Aligns smaller buttons to the bottom
        children: [
          _menuButton(
            context,
            icon: Icons.person, // Changed to person for profile
            label: "profile",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          ),

          // --- THE LARGE SCANNER BUTTON ---
          _menuButton(
            context,
            icon: Icons.document_scanner_outlined, // More specific scanner icon
            label: "Scanner",
            isLarge: true, // Special flag for size
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraPage())),
          ),

          _menuButton(
            context,
            icon: Icons.document_scanner_outlined, // More specific scanner icon
            label: "settings",
            isLarge: true, // Special flag for size
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),

          _menuButton(
            context,
            icon: Icons.history,
            label: "History",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoDetailPage(videoIds: ['qLdOxsqeiRA']))),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        bool isLarge = false, // Default is false
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // If isLarge is true, padding increases from 14 to 22
            padding: EdgeInsets.all(isLarge ? 22 : 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isLarge ? 20 : 16),
              boxShadow: isLarge
                  ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Icon(
              icon,
              size: isLarge ? 32 : 24, // Icon grows from 24 to 32
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLarge ? 14 : 12, // Text gets slightly bigger too
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
