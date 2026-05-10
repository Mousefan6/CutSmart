import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class HistoryService {
  static Future<void> saveScan(Map<String, dynamic> scanData) async {
    final url = Uri.parse("http://10.0.2.2:5000/history/create");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.token}', // SEND THE TOKEN
        },
        body: jsonEncode(scanData),
      );

      if (response.statusCode == 201) {
        print("Scan saved to MongoDB");
      } else {
        print("Failed to save scan: ${response.body}");
      }
    } catch (e) {
      print("Error saving scan: $e");
    }
  }
}
