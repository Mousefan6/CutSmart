import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../UI/app_theme.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;
  final Uint8List imageBytes;

  const FoodDetailPage({
    super.key,
    required this.foodData,
    required this.imageBytes
  });

  @override
  Widget build(BuildContext context) {
    final nutrition = foodData['nutritional_facts_per_100g'] ?? {};
    final tips = List<String>.from(foodData['cutting_safety_tips'] ?? []);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor.value,
      appBar: AppBar(
        title: Text(foodData['name']?.toUpperCase() ?? "DETAILS"),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.accentColor.value,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(imageBytes, width: double.infinity, height: 250, fit: BoxFit.cover),
            ),
            const SizedBox(height: 25),

            // Nutrition Section
            _buildHeader("Nutritional Facts (100g)"),
            Card(
              color: Colors.white.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildNutriRow("Calories", "${nutrition['calories']}"),
                    _buildNutriRow("Protein", "${nutrition['protein']}"),
                    _buildNutriRow("Fat", "${nutrition['fat']}"),
                    _buildNutriRow("Carbs", "${nutrition['carbs']}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Safety Tips Section
            _buildHeader("Cutting Safety Tips"),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.gpp_maybe, color: AppTheme.accentColor.value, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(tip, style: TextStyle(fontSize: 16, color: AppTheme.accentColor.value))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.accentColor.value)),
    );
  }

  Widget _buildNutriRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
