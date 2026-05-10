import 'package:cutsmart/App/Scenes/profile_page.dart';
import 'package:flutter/material.dart';
import '../Scenes/video_page.dart';
import '../Scenes/camera_page.dart';
import '../Scenes/profile_page.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          _menuButton(
            context,
            icon: Icons.save,
            label: "profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),

          _menuButton(
            context,
            icon: Icons.history,
            label: "History",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VideoDetailPage(videoIds: ['qLdOxsqeiRA']),
                ),
              );
            },
          ),



          _menuButton(
            context,
            icon: Icons.settings,
            label: "Scanner",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CameraPage(),
                ),
              );
            },
          ),

          _menuButton(
            context,
            icon: Icons.settings,
            label: "Saved",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SavedPage(),
                ),
              );
            },
          ),


          _menuButton(
            context,
            icon: Icons.save,
            label: "settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
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
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
