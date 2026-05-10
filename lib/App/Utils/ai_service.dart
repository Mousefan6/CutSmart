import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  static Future<String> identifyFood(Uint8List imageBytes) async {
    final prompt = TextPart("I'm going to feed you an image of one veetable/fruit/raw meat.  In one word, and one word only.  Tell me what it is.  I don't want a sentence or anything.  Just the word.");
    final imagePart = DataPart('image/jpeg', imageBytes);

    final response = await _model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    return response.text ?? "unknown";
  }
}
