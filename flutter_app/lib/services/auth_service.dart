import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class AuthService {
  static const String baseUrl = apiBaseUrl;
  static const int timeout = apiTimeout;

  static String _extractErrorMessage(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      final errors = responseData['errors'];
      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty && value.first is String) {
            return value.first as String;
          }
          if (value is String && value.trim().isNotEmpty) {
            return value;
          }
        }
      }
    }

    return fallback;
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(Duration(seconds: timeout));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseData['token'];
        final user = responseData['user'] ?? responseData['data'];

        if (token == null || token.toString().isEmpty) {
          return {
            'success': false,
            'message': 'Token tidak ditemukan dari server.',
          };
        }

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      }

      return {
        'success': false,
        'message': _extractErrorMessage(responseData, 'Login gagal'),
        'errors': responseData is Map<String, dynamic> ? responseData['errors'] : null,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Register user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(Duration(seconds: timeout));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseData['token'];
        final user = responseData['user'] ?? responseData['data'];

        if (token == null || token.toString().isEmpty) {
          return {
            'success': false,
            'message': 'Token tidak ditemukan dari server.',
          };
        }

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      }

      return {
        'success': false,
        'message': _extractErrorMessage(responseData, 'Registrasi gagal'),
        'errors': responseData is Map<String, dynamic> ? responseData['errors'] : null,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getMe(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/me'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeout));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': responseData};
      }

      return {
        'success': false,
        'message': _extractErrorMessage(responseData, 'Gagal mendapatkan data user'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Logout
  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(Duration(seconds: timeout));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logout berhasil'};
      }

      return {
        'success': false,
        'message': _extractErrorMessage(responseData, 'Logout gagal'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
