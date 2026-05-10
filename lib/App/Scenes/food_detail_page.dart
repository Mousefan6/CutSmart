import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../UI/app_theme.dart';
import './video_page.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;
  final Uint8List imageBytes;

  const FoodDetailPage({
    super.key,
    required this.foodData,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    final String name = (foodData['name'] ?? "Food Item").toString().toUpperCase();
    final List tips = foodData['cutting_safety_tips'] ?? [];
    final Map nutrition = foodData['nutritional_facts_per_100g'] ?? {};
    final String query = foodData['video_search_query'] ?? "$name how to cut";

    // We pull the accent color once for easier use
    final Color themeAccent = AppTheme.accentColor.value;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'CutSmart',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: themeAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: themeAccent),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO IMAGE
            Center(
              child: Container(
                height: 280,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: themeAccent.withOpacity(0.2),
                      width: 2
                  ),
                  image: DecorationImage(
                    image: MemoryImage(imageBytes),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 2. DYNAMIC FOOD NAME
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: themeAccent, // Dynamic Color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. NUTRITION SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle("Nutritional Value (100g)", themeAccent),
            ),
            const SizedBox(height: 12),
            _buildNutritionGrid(nutrition, themeAccent),

            const SizedBox(height: 35),

            // 4. SAFETY TIPS SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle("Preparation Safety", themeAccent),
            ),
            const SizedBox(height: 10),
            ...tips.map((tip) => _buildTipTile(tip.toString(), themeAccent)),

            const SizedBox(height: 40),

            // 5. ACTION BUTTON
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoDetailPage(searchQuery: query),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_circle_outline, size: 26),
                    label: const Text(
                      "WATCH TECHNIQUE",
                      style: TextStyle(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeAccent,
                      foregroundColor: AppTheme.backgroundColor.value,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color accent) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: accent.withOpacity(0.8), // Dynamic Opacity
      ),
    );
  }

  Widget _buildNutritionGrid(Map data, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildNutriItem("Calories", data['calories'], accent),
          _buildNutriItem("Protein", data['protein'], accent),
          _buildNutriItem("Fat", data['fat'], accent),
          _buildNutriItem("Carbs", data['carbs'], accent),
        ],
      ),
    );
  }

  Widget _buildNutriItem(String label, dynamic value, Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08), // Dynamic Background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accent.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              label,
              style: TextStyle(color: accent.withOpacity(0.6), fontSize: 11) // Dynamic Label
          ),
          Text(
              value?.toString() ?? "0",
              style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 15) // Dynamic Value
          ),
        ],
      ),
    );
  }

  Widget _buildTipTile(String tip, Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: accent, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                  color: accent.withOpacity(0.9), // Dynamic Text
                  fontSize: 14,
                  height: 1.4
              ),
            ),
          ),
        ],
      ),
    );
  }
}
