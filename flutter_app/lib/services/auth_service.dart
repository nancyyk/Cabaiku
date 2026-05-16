import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class AuthService {
  static const String baseUrl = apiBaseUrl;
  static const int timeout = apiTimeout;

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$',
  );

  static String _sanitizeBase() => baseUrl.replaceAll('\uFEFF', '').trim();

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

  static String _normalizeUserMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('email') &&
        (lower.contains('format') || lower.contains('valid'))) {
      return 'Format email tidak valid.';
    }

    if (lower.contains('email') &&
        (lower.contains('taken') ||
            lower.contains('already') ||
            lower.contains('exist'))) {
      return 'Email sudah terdaftar.';
    }

    if (lower.contains('password') &&
        (lower.contains('min') ||
            lower.contains('minimum') ||
            lower.contains('8'))) {
      return 'Password minimal 8 karakter.';
    }

    if (lower.contains('invalid credential') ||
        lower.contains('credentials') ||
        lower.contains('unauthenticated') ||
        lower.contains('salah')) {
      return 'Email atau password salah.';
    }

    if (lower.contains('not found') ||
        lower.contains('tidak ditemukan') ||
        lower.contains('akun')) {
      return 'Akun tidak ditemukan.';
    }

    return message;
  }

  static bool isValidEmailFormat(String value) {
    return _emailRegex.hasMatch(value.trim());
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final trimmedEmail = email.trim();

      if (!isValidEmailFormat(trimmedEmail)) {
        return {'success': false, 'message': 'Format email tidak valid.'};
      }

      final response = await http
          .post(
            Uri.parse('${_sanitizeBase()}/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': trimmedEmail, 'password': password}),
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

        return {'success': true, 'token': token, 'user': user};
      }

      return {
        'success': false,
        'message': _normalizeUserMessage(
          _extractErrorMessage(responseData, 'Login gagal'),
        ),
        'errors': responseData is Map<String, dynamic>
            ? responseData['errors']
            : null,
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
      final trimmedName = name.trim();
      final trimmedEmail = email.trim();
      final trimmedPhone = phone.trim();

      if (trimmedName.isEmpty || trimmedEmail.isEmpty || trimmedPhone.isEmpty) {
        return {
          'success': false,
          'message': 'Nama, email, dan nomor telepon wajib diisi.',
        };
      }

      if (!isValidEmailFormat(trimmedEmail)) {
        return {'success': false, 'message': 'Format email tidak valid.'};
      }

      final response = await http
          .post(
            Uri.parse('${_sanitizeBase()}/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': trimmedName,
              'email': trimmedEmail,
              'phone': trimmedPhone,
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

        return {'success': true, 'token': token, 'user': user};
      }

      return {
        'success': false,
        'message': _normalizeUserMessage(
          _extractErrorMessage(responseData, 'Registrasi gagal'),
        ),
        'errors': responseData is Map<String, dynamic>
            ? responseData['errors']
            : null,
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
            Uri.parse('${_sanitizeBase()}/me'),
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
        'message': _extractErrorMessage(
          responseData,
          'Gagal mendapatkan data user',
        ),
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
            Uri.parse('${_sanitizeBase()}/logout'),
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
