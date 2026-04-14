import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lahan.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = apiBaseUrl;
  static const int timeout = apiTimeout;

  static Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan. Silakan login ulang.');
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static String _extractErrorMessage(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
        final errors = decoded['errors'];
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
    } catch (_) {
      // Ignore JSON parsing errors and use fallback.
    }
    return fallback;
  }

  static List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic>) return [data];
    }
    return [];
  }

  static Map<String, dynamic> _extractObject(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is Map<String, dynamic>) return data;
      return decoded;
    }
    throw Exception('Format respons tidak valid');
  }

  static Future<List<Lahan>> getLahan() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl/lahans'), headers: headers)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractList(decoded);
        return data
            .whereType<Map<String, dynamic>>()
            .map(Lahan.fromJson)
            .toList();
      }

      if (response.statusCode == 401) {
        throw Exception(
          'Sesi habis atau token tidak valid. Silakan login ulang.',
        );
      }

      if (response.statusCode == 404) {
        return [];
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal memuat lahan (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error loading lahan: $e');
    }
  }

  static Future<Lahan> getLahanById(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl/lahans/$id'), headers: headers)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractObject(decoded);
        return Lahan.fromJson(data);
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal memuat lahan (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error loading lahan: $e');
    }
  }

  static Future<Lahan> createLahan(Lahan lahan) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .post(
            Uri.parse('$baseUrl/lahans'),
            headers: headers,
            body: jsonEncode(lahan.toJson()),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractObject(decoded);
        return Lahan.fromJson(data);
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal menambah lahan (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error creating lahan: $e');
    }
  }

  static Future<Lahan> updateLahan(int id, Lahan lahan) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .put(
            Uri.parse('$baseUrl/lahans/$id'),
            headers: headers,
            body: jsonEncode(lahan.toJson()),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractObject(decoded);
        return Lahan.fromJson(data);
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal mengubah lahan (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error updating lahan: $e');
    }
  }

  static Future<void> deleteLahan(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .delete(Uri.parse('$baseUrl/lahans/$id'), headers: headers)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal menghapus lahan (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error deleting lahan: $e');
    }
  }
}
