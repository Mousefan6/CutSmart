import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/menu_buttons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String message = "Loading...";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPing();
  }

  // Future<void> registerUser() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://10.0.2.2:5000/auth/register'), // Target a register endpoint
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode({
  //         "username": _usernameController.text,
  //         "password": _passwordController.text,
  //       }),
  //     );
  //
  //     final data = json.decode(response.body);
  //     setState(() {
  //       message = data['message'] ?? data['error'];
  //     });
  //   } catch (e) {
  //     setState(() {
  //       message = "Connection failed: $e";
  //     });
  //   }
  // }

  Future<void> register() async {
    final url = Uri.parse('http://10.0.2.2:5000/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': 'mouse',
          'password': 'secret123',
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
  }

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
          message = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        message = "Connection failed";
      });
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

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(color: Color(0xFF7D5334), fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true, // Hides password characters
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7D5334)),
              onPressed: register,
              child: const Text("Register", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
