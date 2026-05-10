import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class AIService {
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
    // This is the "magic" fix:
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
    ),
  );

  static Future<Map<String, dynamic>> identifyFood(Uint8List imageBytes) async {
    final prompt = TextPart(
        "Identify the raw food in this image. Return ONLY a JSON object with: "
            "'name' (one word), 'cutting_safety_tips' (list of strings), "
            "'nutritional_facts_per_100g' (object with calories, protein, fat, carbs), "
            "and 'video_search_query' (a specific YouTube search string for cutting this item)."
    );

    final imagePart = DataPart('image/jpeg', imageBytes);

    try {
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final text = response.text;

      if (text == null || text.isEmpty) {
        return {"error": "No response from AI"};
      }

      // This converts the String into a Map.
      // We cast it as Map<String, dynamic> so Flutter knows how to read the keys.
      return jsonDecode(text) as Map<String, dynamic>;

    } catch (e) {
      // If the JSON is malformed or the network fails, this caught error prevents a crash
      print("Error in AIService: $e");
      return {"error": "Failed to parse data"};
    }
  }
}
