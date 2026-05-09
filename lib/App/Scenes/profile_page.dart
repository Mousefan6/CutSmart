import 'package:flutter/material.dart';
import '../UI/Menu_buttons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The tan background color
      backgroundColor: const Color(0xFFE3D8CD),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFE3D8CD),
        elevation: 0,
        // Manual back arrow themed to match your text color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7D5334)),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'CutSmart',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7D5334),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // Content of the profile page goes here
          const Expanded(
            child: Center(
              child: Text(
                'User Profile',
                style: TextStyle(
                  color: Color(0xFF7D5334),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Your custom menu bar at the bottom
          const BottomMenuBar(),
        ],
      ),
    );
  }
}
