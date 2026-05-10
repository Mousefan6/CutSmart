import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  SessionManager._privateConstructor();

  static final SessionManager instance =
  SessionManager._privateConstructor();

  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  static const String _tokenKey = "session_token";

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> clearToken() async {
    await _storage.delete(
      key: _tokenKey,
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
