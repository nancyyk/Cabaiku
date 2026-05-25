import 'dart:io';

import 'package:flutter/material.dart';

import '../lahan/lahan_model.dart';
import '../../features/disease_care/disease_care_data.dart';
import '../../core/utils/colors.dart';
import 'scan_styles.dart';

Widget buildLahanSection({
  required List<Lahan> lahans,
  required int? selectedLahanId,
  required ValueChanged<int?> onSelectLahan,
}) {
  return _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.map, 'Pilih Lahan'),
        const SizedBox(height: 4),
        const Text(
          'Pilih lahan yang akan dilakukan deteksi',
          style: ScanStyles.sectionLabel,
        ),
        const SizedBox(height: 14),
        ...lahans.map(
          (lahan) => _buildLahanOption(lahan, selectedLahanId, onSelectLahan),
        ),
      ],
    ),
  );
}

Widget _buildLahanOption(
  Lahan lahan,
  int? selectedLahanId,
  ValueChanged<int?> onSelectLahan,
) {
  final isSelected = selectedLahanId == lahan.id;
  return GestureDetector(
    onTap: () => onSelectLahan(lahan.id),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBg : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco, color: Color(0xFF059669), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lahan.namaLahan, style: ScanStyles.optionTitle),
                const SizedBox(height: 2),
                Text(
                  '📍 ${lahan.lokasi}'
                  '${lahan.panjang != null ? ' · ${lahan.panjang} m' : ''}',
                  style: ScanStyles.optionSubtitle,
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: isSelected ? AppColors.primary : Colors.transparent,
            size: 22,
          ),
        ],
      ),
    ),
  );
}

Widget buildUploadSection({
  required File? image,
  required VoidCallback onShowPicker,
  required VoidCallback onRemoveImage,
}) {
  return _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.image, 'Upload Foto Tanaman'),
        const SizedBox(height: 16),
        image == null
            ? _buildDropZone(onShowPicker)
            : _buildPreview(image, onShowPicker, onRemoveImage),
      ],
    ),
  );
}

Widget _buildDropZone(VoidCallback onShowPicker) {
  return GestureDetector(
    onTap: onShowPicker,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBg, Color(0xFFFECDD3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text('📷', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ketuk untuk memilih foto',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Upload foto bagian tanaman yang ingin dideteksi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          const Text(
            'Format: JPG, JPEG, PNG, WEBP · Maks. 5MB',
            style: TextStyle(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPreview(
  File image,
  VoidCallback onShowPicker,
  VoidCallback onRemoveImage,
) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          image,
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: GestureDetector(
          onTap: onRemoveImage,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ),
      Positioned(
        bottom: 10,
        right: 10,
        child: GestureDetector(
          onTap: onShowPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Ganti',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildTipsSection({
  required String resultLabel,
  required int index,
  required List<String> tips,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF93C5FD)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF1E40AF), size: 18),
            SizedBox(width: 8),
            Text(
              'Tips Foto Terbaik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          index >= 0
              ? 'Tips untuk hasil: $resultLabel (index $index)'
              : 'Tips umum untuk pengambilan foto',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        ...tips.map(_tipItem),
      ],
    ),
  );
}

Widget buildDetectionResultSection({
  required Map<String, dynamic> result,
  required File? lastDetectionImage,
  required String? lastDetectionWarning,
  required DiseaseCareContent? diseaseInfo,
  required void Function(String id) onDiseaseDetailPressed,
}) {
  final label = result['hasil']?.toString() ?? 'Tidak diketahui';
  final confidenceText = result['confidence_text']?.toString();
  final confidence = confidenceText ?? '${result['confidence_value'] ?? 0}%';
  final status = result['status']?.toString() ?? 'Valid';
  final saran =
      result['saran']?.toString() ??
      result['rekomendasi']?.toString() ??
      'Belum ada saran tindakan dari AI.';
  final latency = result['latency_ms']?.toString();
  final allScores = result['all_scores'];
  final index = result['index'] as int? ?? -1;

  return _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lastDetectionImage != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              lastDetectionImage,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
        ],
        Row(
          children: [
            const Icon(
              Icons.analytics_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Hasil Deteksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.text,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                index >= 0 ? 'Index $index' : 'Index -',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(label, style: ScanStyles.detectionResultLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _infoChip('Confidence', confidence),
            _infoChip('Status', status),
            if (latency != null) _infoChip('Latency', '$latency ms'),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saran Tindakan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                saran,
                style: const TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (diseaseInfo != null) ...[
          const SizedBox(height: 14),
          _buildDiseaseCareSummary(diseaseInfo, onDiseaseDetailPressed),
        ],
        if (lastDetectionWarning != null && lastDetectionWarning.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              lastDetectionWarning,
              style: const TextStyle(color: AppColors.danger, fontSize: 12),
            ),
          ),
        if (allScores is Map && allScores.isNotEmpty) ...[
          const SizedBox(height: 14),
          const Text(
            'Skor Semua Kelas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          ...allScores.entries.map((entry) {
            final value = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    ),
  );
}

Widget buildSubmitButton({
  required bool isSubmitting,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: isSubmitting ? null : onPressed,
      icon: isSubmitting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : const Icon(Icons.search, color: Colors.white, size: 20),
      label: Text(
        isSubmitting ? 'Sedang Menganalisis...' : 'Mulai Deteksi Sekarang',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    ),
  );
}

Widget _tipItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 5, right: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF3B82F6),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: Text(text, style: ScanStyles.tipBulletText)),
      ],
    ),
  );
}

Widget _infoChip(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(
      '$label: $value',
      style: const TextStyle(fontSize: 12, color: AppColors.text),
    ),
  );
}

Widget _buildDiseaseCareSummary(
  DiseaseCareContent content,
  void Function(String id) onDiseaseDetailPressed,
) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFBEB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFDE68A)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Penyakit: ${content.title}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF92400E),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.overview,
          style: const TextStyle(
            color: Color(0xFF78350F),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        _summaryList('Penanganan', content.handling),
        const SizedBox(height: 8),
        _summaryList('Pencegahan', content.prevention),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onDiseaseDetailPressed(content.id),
            icon: const Icon(Icons.menu_book, size: 18),
            label: const Text('Lihat halaman detail penyakit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF92400E),
              side: const BorderSide(color: Color(0xFFD97706)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _summaryList(String title, List<String> items) {
  final topItems = items.take(2).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: ScanStyles.summaryTitle),
      const SizedBox(height: 4),
      ...topItems.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: Color(0xFF92400E))),
              Expanded(child: Text(item, style: ScanStyles.summaryText)),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
}

Widget _sectionHeader(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(width: 8),
      Text(title, style: ScanStyles.sectionTitle),
    ],
  );
}
