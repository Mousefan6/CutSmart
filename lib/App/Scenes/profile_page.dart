import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Logic variables
  String message = "Connecting to server...";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPing();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // Backend connection check
  Future<void> fetchPing() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/auth'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          message = data['message']; // pong
        });
      } else {
        setState(() {
          message = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Backend Offline";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Server status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.value.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Status: $message",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.accentColor.value.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Icon(Icons.person_add_alt_1,
                          size: 80, color: AppTheme.accentColor.value),
                      const SizedBox(height: 10),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: AppTheme.accentColor.value,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Username Field
                      _buildTextField(
                        controller: _userController,
                        hint: "Username",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 15),

                      // Password Field
                      _buildTextField(
                        controller: _passController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Registering: ${_userController.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor.value,
                            foregroundColor: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
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

  // Themed helper method
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: AppTheme.accentColor.value),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.accentColor.value.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: AppTheme.accentColor.value),
        filled: true,
        // We use the theme's cardColor for contrast against the background
        fillColor: AppTheme.cardColor.value,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}
