import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/colors.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_state.dart';
import 'history_styles.dart';

Widget buildListView(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();

  final total = state.historyData.length;
  final sehat =
      state.historyData.where((e) => _isHealthy(e)).length;
  final sakit = total - sehat;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Riwayat Deteksi', style: HistoryStyles.title),
        const Text(
          'Lihat semua hasil deteksi',
          style: HistoryStyles.subtitle,
        ),
        const SizedBox(height: 16),

        // Stat row
        Row(
          children: [
            _statChip(total.toString(), 'Total', Colors.blueGrey),
            const SizedBox(width: 8),
            _statChip(sehat.toString(), 'Sehat', AppColors.success),
            const SizedBox(width: 8),
            _statChip(sakit.toString(), 'Sakit', AppColors.danger),
          ],
        ),

        const SizedBox(height: 20),

        if (state.historyData.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Belum ada data deteksi',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.historyData.length,
            itemBuilder: (context, i) {
              final item = state.historyData[i];
              return InkWell(
                onTap: () => bloc.selectItem(item),
                borderRadius: BorderRadius.circular(12),
                child: _historyCard(context, item),
              );
            },
          ),
      ],
    ),
  );
}

Widget buildDetailView(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();
  final data = state.selectedData!;

  final id = _toInt(data['id']);
  final hasil = data['hasil']?.toString() ?? '-';
  final isSehat = _isHealthy(data);
  final statusColor = isSehat ? AppColors.success : AppColors.danger;
  final tanggal = _formatDate(data['created_at']?.toString());
  final namaLahan = _getLahanName(data);
  final penyakit = data['penyakit']?.toString();
  final akurasi = data['akurasi']?.toString();
  final tingkat = data['tingkat_keparahan']?.toString();
  final rekomendasi = data['rekomendasi']?.toString();
  final gambarUrl = _getImageUrl(data);

  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan tombol kembali
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => bloc.selectItem(null),
                    ),
                    const Text(
                      'Detail Deteksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Foto hasil deteksi
          if (gambarUrl != null)
            SizedBox(
              width: double.infinity,
              height: 240,
              child: Image.network(
                gambarUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 240,
                    color: AppColors.surface3,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 240,
                  color: AppColors.surface3,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 60,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 180,
              color: AppColors.surface3,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: AppColors.textLight,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSehat ? Icons.check_circle : Icons.warning_rounded,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hasil,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Info lahan & tanggal
                _infoRow(Icons.location_on_outlined, 'Lahan', namaLahan),
                _infoRow(Icons.calendar_today_outlined, 'Tanggal', tanggal),
                if (penyakit != null && penyakit.isNotEmpty)
                  _infoRow(Icons.bug_report_outlined, 'Penyakit', penyakit),
                if (akurasi != null && akurasi.isNotEmpty)
                  _infoRow(
                    Icons.percent,
                    'Akurasi',
                    '$akurasi%',
                  ),
                if (tingkat != null && tingkat.isNotEmpty)
                  _infoRow(
                    Icons.bar_chart_outlined,
                    'Tingkat Keparahan',
                    tingkat,
                  ),

                if (rekomendasi != null && rekomendasi.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Rekomendasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      rekomendasi,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Tombol hapus
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus Riwayat'),
                          content: const Text(
                            'Yakin ingin menghapus riwayat deteksi ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.danger,
                              ),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        bloc.deleteItem(id);
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus Riwayat'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildError(BuildContext context, HistoryState state) {
  final bloc = context.read<HistoryBloc>();

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
          const SizedBox(height: 12),
          Text(
            state.errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => bloc.loadHistory(),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    ),
  );
}

/* ===== helper UI ===== */

Widget _statChip(String value, String label, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    ),
  );
}

Widget _historyCard(BuildContext context, Map<String, dynamic> item) {
  final hasil = item['hasil']?.toString() ?? '-';
  final isSehat = _isHealthy(item);
  final statusColor = isSehat ? AppColors.success : AppColors.danger;
  final tanggal = _formatDate(item['created_at']?.toString());
  final namaLahan = _getLahanName(item);
  final gambarUrl = _getImageUrl(item);

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.border),
    ),
    child: Row(
      children: [
        // Thumbnail foto
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: SizedBox(
            width: 90,
            height: 90,
            child: gambarUrl != null
                ? Image.network(
                    gambarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),
        ),

        // Info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hasil,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Nama lahan
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        namaLahan,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Tanggal
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.chevron_right, color: AppColors.textLight),
        ),
      ],
    ),
  );
}

Widget _imagePlaceholder() {
  return Container(
    color: AppColors.surface3,
    child: const Center(
      child: Icon(Icons.image_outlined, color: AppColors.textLight, size: 30),
    ),
  );
}

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

/* ===== helpers ===== */

bool _isHealthy(Map<String, dynamic> item) {
  final hasil = (item['hasil'] ?? '').toString().toLowerCase().trim();
  return hasil == 'sehat';
}

int _toInt(dynamic v) => int.tryParse(v.toString()) ?? 0;

String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  try {
    final dt = DateTime.parse(raw).toLocal();
    final months = [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  } catch (_) {
    return raw;
  }
}

String _getLahanName(Map<String, dynamic> item) {
  // Coba ambil dari nested object 'lahan'
  final lahan = item['lahan'];
  if (lahan is Map<String, dynamic>) {
    final name = lahan['nama_lahan']?.toString() ??
        lahan['nama']?.toString() ??
        lahan['name']?.toString();
    if (name != null && name.isNotEmpty) return name;
  }
  // Fallback ke field langsung
  final namaLahan = item['nama_lahan']?.toString() ??
      item['lahan_name']?.toString() ??
      item['lahan_nama']?.toString();
  if (namaLahan != null && namaLahan.isNotEmpty) return namaLahan;

  final lahanId = item['lahan_id']?.toString();
  if (lahanId != null && lahanId.isNotEmpty) return 'Lahan #$lahanId';

  return '-';
}

String? _getImageUrl(Map<String, dynamic> item) {
  // Cek field gambar langsung
  final gambar = item['gambar']?.toString() ??
      item['foto']?.toString() ??
      item['image']?.toString() ??
      item['image_url']?.toString() ??
      item['gambar_url']?.toString();

  if (gambar == null || gambar.isEmpty) return null;

  // Jika sudah URL lengkap
  if (gambar.startsWith('http')) return gambar;

  // Jika path relatif, gabungkan dengan base URL
  final base = ApiService.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
  return '$base/storage/$gambar';
}
