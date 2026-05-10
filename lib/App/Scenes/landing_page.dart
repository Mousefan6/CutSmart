import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error: Could not find .env file.");
  }
  runApp(const LandingApp());
}

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE3D8CD),
        fontFamily: 'sans-serif',
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const CameraPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFB08968),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 38 / 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
