import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String message = "Create Account";
  bool sendNotifications = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> register() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPw = _confirmPasswordController.text;

    if (password != confirmPw) {
      setState(() => message = "Passwords do not match!");
      return;
    }
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => message = "Please fill in all fields");
      return;
    }
    final url = Uri.parse("http://10.0.2.2:5000/auth/register");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          // 'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Success: $data');
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Connection Error: $e');
    }
  } // NEED TO FIX AND CONNECT TO DATABASE

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
                        controller: _usernameController,
                        hint: "Username",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 15),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 15),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 15),

                      // CONFIRM Password Field
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: "Confirm Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Registering: ${_usernameController.text}");
                            register();
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

                      const SizedBox(height: 20), // For spacing

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 16, fontFamily: 'Georgia'),
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: AppTheme.accentColor.value,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: AppTheme.accentColor.value,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
