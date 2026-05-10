import 'package:flutter/material.dart';
import '../UI/app_theme.dart'; // Ensure path to AppTheme is correct
import 'camera_page.dart';

class SnapPage extends StatelessWidget {
  const SnapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for color changes globally
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              // Back arrow follows accent color
              icon: Icon(Icons.arrow_back, color: AppTheme.accentColor.value),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                children: [
                  // Step Cards
                  _buildStepCard('assets/mousesnap1.png', 'Snap!'),
                  const SizedBox(height: 20),
                  _buildStepCard('assets/mousephone.png', 'Watch!'),
                  const SizedBox(height: 20),
                  _buildStepCard('assets/mousecut.png', 'Cut Smart!'),

                  const SizedBox(height: 40),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CameraPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Button color follows accent color
                        backgroundColor: AppTheme.accentColor.value,
                        // Text color follows background (contrast)
                        foregroundColor: bgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Updated helper method to use themed card and text colors
  Widget _buildStepCard(String assetPath, String title) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        // Uses the themed card color (usually white, or dark in dark palettes)
        color: AppTheme.cardColor.value,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              // Title text follows accent color for consistency
              color: AppTheme.accentColor.value,
            ),
          ),
        ],
      ),
    );
  }
}
