import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/app_theme.dart';
import './video_page.dart'; // Ensure this path is correct

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;
  final Uint8List imageBytes;

  const FoodDetailPage({
    super.key,
    required this.foodData,
    required this.imageBytes,
  });

  Future<void> _autoSaveToHistory() async {
    final token = await SessionManager.instance.getToken();

    if (token == null) {
      debugPrint("Auth Error: No token found in secure storage.");
      return;
    }
    final url = Uri.parse('http://10.0.2.2:5000/history/save');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Passing the secure token
        },
        body: jsonEncode({
          'food_name': foodData['name'] ?? "Unknown Food",
          'nutrition': foodData['nutritional_facts_per_100g'] ?? {},
        }),
      );

      if (response.statusCode == 201) {
        debugPrint("Successfully auto-saved to database.");
      } else {
        debugPrint("Server rejected save: ${response.body}");
      }
    } catch (e) {
      debugPrint("Network Error during auto-save: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extracting data with fallbacks
    final String name = (foodData['name'] ?? "Food Item").toString().toUpperCase();
    final List tips = foodData['cutting_safety_tips'] ?? [];
    final Map nutrition = foodData['nutritional_facts_per_100g'] ?? {};
    final String? videoId = foodData['youtube_video_id'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back arrow
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          name,
          style: TextStyle(
            color: AppTheme.accentColor.value,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppTheme.accentColor.value),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGE HEADER
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 2. NUTRITION GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle("Nutritional Value (100g)"),
            ),
            const SizedBox(height: 10),
            _buildNutritionGrid(nutrition),

            const SizedBox(height: 30),

            // 3. SAFETY TIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionTitle("Cutting Safety Tips"),
            ),
            ...tips.map((tip) => _buildTipTile(tip.toString())),

            const SizedBox(height: 40),

            // 4. ACTION BUTTON
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    // Inside the ElevatedButton in food_detail_page.dart
                    onPressed: () {
                      final String query = foodData['video_search_query'] ?? "${foodData['name']} how to cut";

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoDetailPage(searchQuery: query), // Passing query now
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_circle_fill, size: 28),
                    label: const Text(
                      "WATCH HOW TO CUT",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.accentColor.value,
      ),
    );
  }

  Widget _buildNutritionGrid(Map data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          _buildNutriItem("Calories", data['calories']),
          _buildNutriItem("Protein", data['protein']),
          _buildNutriItem("Fat", data['fat']),
          _buildNutriItem("Carbs", data['carbs']),
        ],
      ),
    );
  }

  Widget _buildNutriItem(String label, dynamic value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          Text(value?.toString() ?? "0", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTipTile(String tip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
