import 'package:flutter/material.dart';
import '../UI/app_theme.dart';
import 'camera_page.dart';

class SnapPage extends StatelessWidget {
  const SnapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.accentColor.value),
              onPressed: () => Navigator.pop(context),
            ),
            // Consistent Branding
            title: Text(
              'CutSmart',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.w900,
                fontSize: 28,
                color: AppTheme.accentColor.value,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Tutorial Step Cards
                  _buildStepCard('assets/mousesnap1.png', 'Snap!'),
                  const SizedBox(height: 16),
                  _buildStepCard('assets/mousephone.png', 'Watch!'),
                  const SizedBox(height: 16),
                  _buildStepCard('assets/mousecut.png', 'Cut Smart!'),

                  const Spacer(flex: 3),

                  // Action Button - Moved up with bottom padding
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0), // Adjust this value to move it higher/lower
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CameraPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor.value,
                          foregroundColor: bgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepCard(String assetPath, String title) {
    return Container(
      width: double.infinity,
      height: 140, // Slightly tighter height to ensure everything fits perfectly
      decoration: BoxDecoration(
        color: AppTheme.cardColor.value,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
