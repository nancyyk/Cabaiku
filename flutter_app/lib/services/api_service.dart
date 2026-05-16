import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lahan.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = apiBaseUrl;
  static const String aiBaseUrl = aiServiceBaseUrl;
  static const int timeout = apiTimeout;

  static String _sanitizeBase() => baseUrl.replaceAll('\uFEFF', '').trim();
  static String _sanitizeAiBase() {
    final raw = aiBaseUrl.replaceAll('\uFEFF', '').trim();

    // Android emulator cannot reach host localhost directly.
    try {
      final uri = Uri.parse(raw);
      final isLocalhost = uri.host == '127.0.0.1' || uri.host == 'localhost';
      if (isLocalhost && Platform.isAndroid) {
        return uri.replace(host: '10.0.2.2').toString();
      }
    } catch (_) {
      // Fall back to raw value when URL parsing fails.
    }

    return raw;
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw Exception('Gagal membaca sesi login. Coba restart aplikasi.');
      },
    );
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

  static String? _pickStringFromMaps(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  static num? _pickNumFromMaps(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final value = map[key];
        if (value is num) return value;
        if (value is String && value.trim().isNotEmpty) {
          final parsed = num.tryParse(value.trim());
          if (parsed != null) return parsed;
        }
      }
    }
    return null;
  }

  static String _severityFromAccuracy(int accuracy) {
    if (accuracy >= 85) return 'Ringan';
    if (accuracy >= 70) return 'Sedang';
    return 'Berat';
  }

  static Map<String, dynamic> _fallbackPrediction({String? warning}) {
    return {
      'hasil': 'Analisis AI belum tersedia',
      'penyakit': null,
      'akurasi': 0,
      'tingkat_keparahan': 'Ringan',
      'rekomendasi':
          'Pastikan service AI aktif, lalu lakukan deteksi ulang untuk hasil prediksi.',
      if (warning != null && warning.trim().isNotEmpty) 'warning': warning,
    };
  }

  static Future<Map<String, dynamic>> _predictWithAi(File gambar) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('${_sanitizeAiBase()}/predict'))
          ..headers['Accept'] = 'application/json'
          ..files.add(await http.MultipartFile.fromPath('file', gambar.path));

    final streamed = await request.send().timeout(Duration(seconds: timeout));
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw Exception(
        _extractErrorMessage(body, 'AI service gagal (${streamed.statusCode})'),
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw Exception('Respons AI tidak valid (bukan JSON).');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Format respons AI tidak didukung.');
    }

    final nestedData = decoded['data'];
    final nestedResult = decoded['result'];
    final nestedPrediction = decoded['prediction'];
    final analysisDetails = decoded['analysis_details'];

    final maps = <Map<String, dynamic>>[
      decoded,
      if (nestedData is Map<String, dynamic>) nestedData,
      if (nestedResult is Map<String, dynamic>) nestedResult,
      if (nestedPrediction is Map<String, dynamic>) nestedPrediction,
      if (analysisDetails is Map<String, dynamic>) analysisDetails,
    ];

    final hasil =
        _pickStringFromMaps(maps, ['hasil', 'label', 'class', 'prediction']) ??
        'Hasil tidak diketahui';

    final penyakit = _pickStringFromMaps(maps, ['penyakit', 'disease']);

    final rawConfidence = _pickNumFromMaps(maps, [
      'confidence',
      'akurasi',
      'score',
      'probability',
    ]);

    final confidenceText = _pickStringFromMaps(maps, [
      'confidence',
      'akurasi',
      'score',
      'probability',
    ]);

    int accuracy = 0;
    if (rawConfidence != null) {
      final normalized = rawConfidence <= 1
          ? rawConfidence * 100
          : rawConfidence;
      accuracy = normalized.round().clamp(0, 100);
    }

    final tingkat =
        _pickStringFromMaps(maps, ['tingkat_keparahan', 'severity']) ??
        _severityFromAccuracy(accuracy);

    final status = _pickStringFromMaps(maps, ['status']) ?? 'Valid';

    final saran = _pickStringFromMaps(maps, [
      'saran',
      'rekomendasi',
      'recommendation',
    ]);

    final latencyMs = _pickNumFromMaps(maps, ['latency_ms', 'latency']);

    final allScores = (() {
      if (analysisDetails is Map<String, dynamic>) {
        final scores = analysisDetails['all_scores'];
        if (scores is Map<String, dynamic>) return scores;
      }
      return null;
    })();

    final rekomendasi = _pickStringFromMaps(maps, [
      'rekomendasi',
      'recommendation',
    ]);

    return {
      'prediction_class': hasil,
      'confidence_text': confidenceText,
      'confidence_value': accuracy,
      'status': status,
      'saran': saran,
      'latency_ms': latencyMs,
      'all_scores': allScores,
      'hasil': hasil,
      'penyakit': hasil.toLowerCase() == 'sehat' ? null : (penyakit ?? hasil),
      'akurasi': accuracy,
      'tingkat_keparahan': tingkat,
      'rekomendasi': saran ?? rekomendasi,
      'raw_ai_response': decoded,
    };
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

  static Future<List<Map<String, dynamic>>> getDeteksis() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .get(Uri.parse('${_sanitizeBase()}/deteksis'), headers: headers)
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = _extractList(decoded);
        return data.whereType<Map<String, dynamic>>().toList();
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal memuat riwayat deteksi (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error loading deteksi: $e');
    }
  }

  static Future<void> deleteDeteksi(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http
          .delete(
            Uri.parse('${_sanitizeBase()}/deteksis/$id'),
            headers: headers,
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      throw Exception(
        _extractErrorMessage(
          response.body,
          'Gagal menghapus riwayat deteksi (${response.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error deleting deteksi: $e');
    }
  }

  /// Kirim gambar + lahan_id + catatan ke endpoint POST /deteksis.
  /// Backend membutuhkan multipart/form-data karena ada file gambar.
  static Future<Map<String, dynamic>> createDeteksi({
    required int lahanId,
    required File gambar,
    String? catatan,
  }) async {
    try {
      Map<String, dynamic> aiPrediction;
      String? aiWarning;
      try {
        aiPrediction = await _predictWithAi(gambar);
      } on SocketException {
        aiWarning =
            'Tidak bisa terhubung ke AI service (${_sanitizeAiBase()}). '
            'Jika pakai emulator/device, jangan gunakan 127.0.0.1; gunakan IP laptop/server.';
        aiPrediction = _fallbackPrediction(warning: aiWarning);
      } catch (e) {
        aiWarning = 'AI service tidak tersedia: $e';
        aiPrediction = _fallbackPrediction(warning: aiWarning);
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan. Silakan login ulang.');
      }

      final uri = Uri.parse('${_sanitizeBase()}/deteksis');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['lahan_id'] = lahanId.toString()
        ..fields['hasil'] = aiPrediction['hasil'].toString()
        ..fields['tingkat_keparahan'] = aiPrediction['tingkat_keparahan']
            .toString()
        ..fields['akurasi'] = aiPrediction['akurasi'].toString();

      final penyakit = aiPrediction['penyakit']?.toString();
      if (penyakit != null && penyakit.trim().isNotEmpty) {
        request.fields['penyakit'] = penyakit.trim();
      }

      final rekomendasi = aiPrediction['rekomendasi']?.toString();
      if (rekomendasi != null && rekomendasi.trim().isNotEmpty) {
        request.fields['rekomendasi'] = rekomendasi.trim();
      }

      if (catatan != null && catatan.trim().isNotEmpty) {
        request.fields['catatan'] = catatan.trim();
      }

      final ext = gambar.path.split('.').last.toLowerCase();
      final mimeType = switch (ext) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };

      request.files.add(
        await http.MultipartFile.fromPath(
          'gambar',
          gambar.path,
          contentType: http.MediaType.parse(mimeType),
        ),
      );

      final streamed = await request.send().timeout(Duration(seconds: timeout));
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final payload = jsonDecode(body) as Map<String, dynamic>;
        payload['ai_prediction'] = aiPrediction;
        if (aiWarning != null) {
          payload['ai_warning'] = aiWarning;
        }
        return payload;
      }

      throw Exception(
        _extractErrorMessage(
          body,
          'Gagal mengirim deteksi (${streamed.statusCode})',
        ),
      );
    } catch (e) {
      throw Exception('Error creating deteksi: $e');
    }
  }
}
