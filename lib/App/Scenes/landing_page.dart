import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'tutorial.dart'; // SnapPage
import '../UI/app_theme.dart'; // Import your theme system

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
    // We listen to the global background color here so the whole app shell updates
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CutSmart',
          theme: ThemeData(
            // Apply the global background color to the theme
            scaffoldBackgroundColor: bgColor,
            fontFamily: 'sans-serif',
            useMaterial3: true,
          ),
          home: const LandingPage(),
        );
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for theme changes on the Landing Page
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // 1. Main Title - Uses Accent Color
                  Text(
                    'CutSmart',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.accentColor.value, // THEMED
                      letterSpacing: -1.5,
                      fontFamily: 'Georgia', // Matching your other titles
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. Tagline - Uses Accent Color with opacity
                  Text(
                    'Perfect cuts just one photo away',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.accentColor.value.withOpacity(0.8), // THEMED
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
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const SnapPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppTheme.accentColor.value, // THEMED
                        foregroundColor: bgColor, // Contrast text color
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
      },
    );
  }
}
