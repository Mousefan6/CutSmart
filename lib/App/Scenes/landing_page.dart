import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- Missing this
import 'tutorial.dart'; // This allows us to see SnapPage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    debugPrint("Env loaded: ${dotenv.env['GEMINI_API_KEY'] != null}");
  } catch (e) {
    debugPrint("Failed to load .env: $e");
  }

  runApp(const CutSmartApp());
}

class CutSmartApp extends StatelessWidget {
  const CutSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CutSmart',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE3D8CD),
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      // This tells Flutter to show the LandingPage immediately on startup
      home: const LandingPage(),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // 1. Main Title
              const Text(
                'CutSmart',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3B2F2F),
                  letterSpacing: -1.5,
                ),
              ),

              const SizedBox(height: 12),

              // 2. Tagline
              const Text(
                'AI-powered precision for every project.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF7F5539),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 4),

              // 3. Action Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // This links directly to the SnapPage in tutorial.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const SnapPage(),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
