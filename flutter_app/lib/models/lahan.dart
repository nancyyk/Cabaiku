import 'package:intl/intl.dart';

class Lahan {
  final int? id;
  final String namaLahan;
  final String lokasi;
  final double? panjang;
  final double? lebar;
  final String? keterangan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Lahan({
    this.id,
    required this.namaLahan,
    required this.lokasi,
    this.panjang,
    this.lebar,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  factory Lahan.fromJson(Map<String, dynamic> json) {
    return Lahan(
      id: _parseInt(json['id']),
      namaLahan: (json['nama_lahan'] ?? json['namaLahan'] ?? '').toString(),
      lokasi: (json['lokasi'] ?? '').toString(),
      panjang: _parseDouble(json['panjang']),
      lebar: _parseDouble(json['lebar']),
      keterangan: _parseString(json['keterangan']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lahan': namaLahan,
      'lokasi': lokasi,
      'panjang': panjang,
      'lebar': lebar,
      'keterangan': keterangan,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    return result.isEmpty ? null : result;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  String get formattedDate {
    if (createdAt == null) return '';
    return DateFormat('d MMM y', 'id_ID').format(createdAt!);
  }
}
