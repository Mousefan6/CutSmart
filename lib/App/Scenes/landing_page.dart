import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'tutorial.dart'; // SnapPage
import '../UI/app_theme.dart'; // Ensure this path is correct

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
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // --- Header Section ---
                  Text(
                    'CutSmart',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.accentColor.value,
                      letterSpacing: -2.0,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),


                  const Spacer(flex: 2),

                  // --- Central Logo Section ---
                  // Wrap in a Hero for a smooth transition to the next screen
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Image.asset(
                        'assets/Logo.png',
                        fit: BoxFit.contain,
                        // If the logo is a silhouette, uncomment the line below
                        // to make it match your theme color automatically:
                        // color: AppTheme.accentColor.value,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),
                  Text(
                    'Perfect cuts just one photo away',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.accentColor.value.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(flex: 4),

                  // --- Action Section ---
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 64,
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
                            backgroundColor: AppTheme.accentColor.value,
                            foregroundColor: bgColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Optional version or subtle footer
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: AppTheme.accentColor.value.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

