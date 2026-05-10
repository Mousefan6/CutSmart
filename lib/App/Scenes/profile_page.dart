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

  @override
  void initState() {
    super.initState();
    fetchPing();
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

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF7D5334),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const BottomMenuBar(),
        ],
      ),
    );
  }
}
