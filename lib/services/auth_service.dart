// UC01, UC02, UC03: Authentication Service
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_session.dart';
import 'api_config.dart';

class AuthResult {
  final bool success;
  final UserSession? session;
  final String? errorMessage;
  final bool isAlreadyRegistered; // UC01 alternative flow
  final bool isNoAccount; // UC02 alternative flow
  final bool isSuspended; // UC02 alternative flow

  const AuthResult({
    required this.success,
    this.session,
    this.errorMessage,
    this.isAlreadyRegistered = false,
    this.isNoAccount = false,
    this.isSuspended = false,
  });
}

class AuthService {
  static const String _tokenKey = 'docsphere_auth_token';
  static const String _userKey = 'docsphere_auth_user';

  // UC01: Register Account
  static Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/auth/register');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': fullName.trim(),
              'email': email.trim().toLowerCase(),
              'password': password,
              'confirmPassword': confirmPassword,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['success'] == true) {
        final token = data['token'] as String;
        final session = UserSession.fromJson(data, token);
        await _saveSession(session);
        return AuthResult(success: true, session: session);
      } else {
        return AuthResult(
          success: false,
          errorMessage: data['message'] as String? ?? 'Registration failed',
          isAlreadyRegistered: data['alreadyRegistered'] == true,
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Unable to connect to DocSphere server: ${e.toString()}',
      );
    }
  }

  // UC02: Log In
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['token'] as String;
        final session = UserSession.fromJson(data, token);
        await _saveSession(session);
        return AuthResult(success: true, session: session);
      } else {
        return AuthResult(
          success: false,
          errorMessage: data['message'] as String? ?? 'Login failed',
          isNoAccount: data['noAccount'] == true,
          isSuspended: data['isSuspended'] == true,
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Unable to connect to DocSphere server: ${e.toString()}',
      );
    }
  }

  // UC03: Log Out
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null) {
        final url = Uri.parse('${ApiConfig.baseUrl}/auth/logout');
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(const Duration(seconds: 3));
      }
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    }
  }

  // Session storage helpers
  static Future<void> _saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, session.token);
    await prefs.setString(_userKey, jsonEncode(session.toJson()));
  }

  static Future<UserSession?> getSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);
      if (token != null && userJson != null) {
        final data = jsonDecode(userJson) as Map<String, dynamic>;
        return UserSession.fromJson(data, token);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
