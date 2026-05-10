import 'package:flutter/material.dart';
import '../UI/app_theme.dart';
import '../UI/menu_buttons.dart';
import '../Utils/session_manager.dart';
import 'login_page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final token = await SessionManager.instance.getToken();

      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/profile"),
        headers: {
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          profile = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          profile = {
            "username": "Error",
            "email": "Backend failed"
          };
        });
      }

    } catch (e) {
      setState(() {
        loading = false;
        profile = {
          "username": "Offline",
          "email": "Cannot reach server"
        };
      });

      debugPrint("Profile load failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.accentColor,
      builder: (context, Color accentColor, child) {

        if (loading) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor.value,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor.value,

          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "PROFILE",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [

                      const SizedBox(height: 30),

                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: accentColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: accentColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      _infoBox(
                        "Username",
                        profile?["username"] ?? "Unknown",
                        accentColor,
                      ),

                      _infoBox(
                        "Email",
                        profile?["email"] ?? "Unknown",
                        accentColor,
                      ),

                      _infoBox(
                        "App Version",
                        "1.0.0 (Beta)",
                        accentColor,
                      ),

                      const SizedBox(height: 40),

                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          side: BorderSide(color: accentColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await SessionManager.instance.clearToken();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                                  (route) => false,
                            );
                          }
                        },
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
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

  Widget _infoBox(String label, String value, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.value,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: accentColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
