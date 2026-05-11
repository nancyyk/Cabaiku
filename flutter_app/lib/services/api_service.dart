import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lahan.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = apiBaseUrl;
  static const int timeout = apiTimeout;

  static String _sanitizeBase() => baseUrl.replaceAll('\uFEFF', '').trim();

  static Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance()
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception('Gagal membaca sesi login. Coba restart aplikasi.');
    });
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
          .get(Uri.parse('${_sanitizeBase()}/lahans'), headers: headers)
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
          .get(Uri.parse('${_sanitizeBase()}/lahans/$id'), headers: headers)
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
            Uri.parse('${_sanitizeBase()}/lahans'),
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
            Uri.parse('${_sanitizeBase()}/lahans/$id'),
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
          .delete(Uri.parse('${_sanitizeBase()}/lahans/$id'), headers: headers)
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

  // ─── Deteksi ────────────────────────────────────────────────────────────────

  /// Kirim gambar + lahan_id + catatan ke endpoint POST /deteksis.
  /// Backend membutuhkan multipart/form-data karena ada file gambar.
  static Future<Map<String, dynamic>> createDeteksi({
    required int lahanId,
    required File gambar,
    String? catatan,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan. Silakan login ulang.');
      }

      final uri = Uri.parse('${_sanitizeBase()}/deteksis');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['lahan_id'] = lahanId.toString();

      if (catatan != null && catatan.trim().isNotEmpty) {
        request.fields['catatan'] = catatan.trim();
      }

      final ext = gambar.path.split('.').last.toLowerCase();
      final mimeType = switch (ext) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };

      request.files.add(await http.MultipartFile.fromPath(
        'gambar',
        gambar.path,
        contentType: http.MediaType.parse(mimeType),
      ));

      final streamed = await request.send().timeout(Duration(seconds: timeout));
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        return jsonDecode(body) as Map<String, dynamic>;
      }

      throw Exception(
        _extractErrorMessage(body, 'Gagal mengirim deteksi (${streamed.statusCode})'),
      );
    } catch (e) {
      throw Exception('Error creating deteksi: $e');
    }
  }
}
