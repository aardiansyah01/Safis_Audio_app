import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _isLoggedInKey = "is_logged_in";
  static const String _usernameKey = "username";
  static const String _emailKey = "email";

  static Future<void> saveLogin({
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_usernameKey) ?? "";
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_emailKey) ?? "";
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
  }
}
