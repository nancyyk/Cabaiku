import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, dynamic>? _selectedData;
  List<Map<String, dynamic>> historyData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getDeteksis();
      if (!mounted) return;

      setState(() {
        historyData = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteItemById(int id) async {
    final confirmed = await _showDeleteConfirmation();
    if (confirmed != true) return;

    try {
      await ApiService.deleteDeteksi(id);
      if (!mounted) return;

      setState(() {
        historyData.removeWhere((item) => _toInt(item['id']) == id);
        if (_selectedData != null && _toInt(_selectedData!['id']) == id) {
          _selectedData = null;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat berhasil dihapus'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus riwayat deteksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedData != null) {
      return _buildDetailView(_selectedData!);
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.danger,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.danger),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildListView();
  }

  Widget _buildListView() {
    final totalDeteksi = historyData.length;
    final tanamanSehat = historyData.where((item) => _isHealthy(item)).length;
    final terdeteksiPenyakit = totalDeteksi - tanamanSehat;

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Deteksi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Lihat semua hasil deteksi penyakit tanaman cabai Anda',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _buildStatCard(
              totalDeteksi.toString(),
              'Total Deteksi',
              Colors.black,
            ),
            _buildStatCard(
              tanamanSehat.toString(),
              'Tanaman Sehat',
              Colors.green,
              icon: Icons.check_circle_outline,
            ),
            _buildStatCard(
              terdeteksiPenyakit.toString(),
              'Terdeteksi Penyakit',
              Colors.red,
              icon: Icons.error_outline,
            ),
            const SizedBox(height: 24),
            if (historyData.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Belum ada riwayat deteksi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  return InkWell(
                    onTap: () => setState(() => _selectedData = item),
                    child: _buildHistoryItem(item),
                  );
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView(Map<String, dynamic> data) {
    final status = _stringOf(data['hasil']);
    final tingkat = _stringOf(data['tingkat_keparahan']);
    final akurasi = _toInt(data['akurasi']);
    final lahanName = _lahanNameOf(data);
    final createdAt = _parseDateTime(data['created_at']);
    final id = _toInt(data['id']);
    final isHealthy = _isHealthy(data);

    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedData = null),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 16, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Kembali ke Riwayat',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          isHealthy ? Icons.check_circle : Icons.error,
                          color: isHealthy ? Colors.green : Colors.red,
                          size: 48,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Lahan: $lahanName',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge(
                          tingkat.isEmpty ? 'Tidak diketahui' : tingkat,
                          isHealthy ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _buildBadge('Akurasi: $akurasi%', Colors.blueGrey),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTanggal(createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatJam(createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Hasil deteksi ini disimpan untuk referensi Anda. Untuk deteksi baru, silakan kunjungi halaman Deteksi.',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: id == 0 ? null : () => _deleteItemById(id),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Hapus Riwayat Ini',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color, {
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: color, size: 24),
              if (icon != null) const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final isHealthy = _isHealthy(item);
    final status = _stringOf(item['hasil']);
    final tingkat = _stringOf(item['tingkat_keparahan']);
    final akurasi = _toInt(item['akurasi']);
    final createdAt = _parseDateTime(item['created_at']);
    final lahanName = _lahanNameOf(item);
    final id = _toInt(item['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy ? Icons.check_circle : Icons.error,
                color: isHealthy ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: id == 0 ? null : () => _deleteItemById(id),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                splashRadius: 18,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Lahan: $lahanName',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildBadge(
                tingkat.isEmpty ? 'Tidak diketahui' : tingkat,
                isHealthy ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              _buildBadge(
                '$akurasi% akurat',
                const Color.fromARGB(255, 83, 95, 105),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _formatTanggal(createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _formatJam(createdAt),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  bool _isHealthy(Map<String, dynamic> item) {
    final hasil = _stringOf(item['hasil']).toLowerCase();
    return hasil.contains('sehat') || hasil.contains('healthy');
  }

  String _lahanNameOf(Map<String, dynamic> item) {
    final lahan = item['lahan'];
    if (lahan is Map) {
      final map = Map<String, dynamic>.from(lahan as Map);
      final nama = map['nama_lahan'] ?? map['namaLahan'] ?? map['nama'];
      final label = _stringOf(nama);
      if (label.isNotEmpty) {
        return label;
      }
    }
    return 'Lahan tidak diketahui';
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _stringOf(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  DateTime? _parseDateTime(dynamic value) {
    final raw = _stringOf(value);
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw)?.toLocal();
  }

  String _formatTanggal(DateTime? dateTime) {
    if (dateTime == null) return '-';
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final month = months[dateTime.month - 1];
    return '${dateTime.day} $month ${dateTime.year}';
  }

  String _formatJam(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
