import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/session_manager.dart';

class HistoryService {

  static Future<void> saveScan(
      Map<String, dynamic> scanData,
      ) async {

    final token =
    await SessionManager.instance.getToken();

    await http.post(
      Uri.parse(
        "http://10.0.2.2:5000/history/add",
      ),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },

      body: jsonEncode(scanData),
    );
  }
}
