import 'package:cutsmart/App/Scenes/register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = "Welcome Back";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('http://10.0.2.2:5000/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Navigate to Home/Profile on success
        print("Login Success");
      } else {
        setState(() => message = "Login Failed");
      }
    } catch (e) {
      setState(() => message = "Connection Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3D8CD),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFE3D8CD),
        elevation: 0,
        title: const Text('CutSmart', style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontStyle: FontStyle.italic, fontWeight: FontWeight.w700, color: Color(0xFF7D5334))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(color: Color(0xFF7D5334), fontSize: 18)),
            const SizedBox(height: 20),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7D5334), minimumSize: const Size(double.infinity, 50)),
              onPressed: login,
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20), // For spacing between login button and register link
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, fontFamily: 'Georgia'), // Base style
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Color(0xFF7D5334)), // Your Theme Brown
                    ),
                    TextSpan(
                      text: "Register here",
                      style: TextStyle(
                        color: Colors.blue,
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
    );
  }
}
