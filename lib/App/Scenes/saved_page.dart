import 'package:flutter/material.dart';
import '../UI/menu_buttons.dart';
import '../UI/app_theme.dart'; // Ensure this points to your theme file

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.backgroundColor,
      builder: (context, Color bgColor, child) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: bgColor,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Saved Items',
                        style: TextStyle(
                          color: AppTheme.accentColor.value,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Example of a themed list of saved items
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3, // Placeholder count
                          itemBuilder: (context, index) {
                            return _buildSavedCard(
                              title: "Saved Project ${index + 1}",
                              date: "May 2026",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // The global menu bar already handles its own theming!
              const BottomMenuBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavedCard({required String title, required String date}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.value, // Follows the palette
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.value.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bookmark, color: AppTheme.accentColor.value),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.accentColor.value,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.accentColor.value.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: AppTheme.accentColor.value.withOpacity(0.3)),
        ],
      ),
    );
  }
}
