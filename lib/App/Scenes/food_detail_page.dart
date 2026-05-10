import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UI/app_theme.dart';
import '../Utils/session_manager.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;
  final Uint8List imageBytes;

  const FoodDetailPage({
    super.key,
    required this.foodData,
    required this.imageBytes
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
    // Triggers save function for history when widget is built
    Future.microtask(() => _autoSaveToHistory());

    final nutrition = foodData['nutritional_facts_per_100g'] ?? {};
    final tips = List<String>.from(foodData['cutting_safety_tips'] ?? []);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor.value,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          foodData['name']?.toUpperCase() ?? "DETAILS",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
              child: Image.memory(
                  imageBytes,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover
              ),
            ),
            const SizedBox(height: 25),

            // Nutrition Section
            _buildHeader("Nutritional Facts (100g)"),
            Card(
              color: AppTheme.cardColor.value,
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
                  Expanded(
                      child: Text(
                          tip,
                          style: TextStyle(fontSize: 16, color: AppTheme.accentColor.value)
                      )
                  ),
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
      child: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentColor.value
          )
      ),
    );
  }

  Widget _buildNutriRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.accentColor.value.withOpacity(0.7))),
          Text(value, style: TextStyle(color: AppTheme.accentColor.value, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
