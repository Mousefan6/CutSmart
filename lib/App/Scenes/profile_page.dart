import 'package:flutter/material.dart';
import '../UI/app_theme.dart';
import '../Utils/session_manager.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.accentColor,
      builder: (context, Color accentColor, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor.value,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("PROFILE", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // --- PROFILE PICTURE ---
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: accentColor.withOpacity(0.1),
                    child: Icon(Icons.person, size: 70, color: accentColor),
                  ),
                ),

                const SizedBox(height: 40),

                // --- INFO BOXES ---
                _infoBox("Username", "Jaden", accentColor),
                _infoBox("Email", "jaden@example.com", accentColor),
                _infoBox("App Version", "1.0.0 (Beta)", accentColor),

                const Spacer(),

                // --- LOGOUT BUTTON ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      side: BorderSide(color: accentColor, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await SessionManager.instance.clearToken();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                        );
                      }
                    },
                    child: Text("LOGOUT", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoBox(String label, String value, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.value,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: accentColor.withOpacity(0.6))),
          Text(value, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
