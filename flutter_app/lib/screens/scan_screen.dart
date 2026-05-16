import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/lahan.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import 'disease_care/bacterial_spot_page.dart';
import 'disease_care/cercospora_leaf_spot_page.dart';
import 'disease_care/curl_virus_page.dart';
import 'disease_care/disease_care_data.dart';
import 'disease_care/healthy_leaf_page.dart';
import 'disease_care/nutrition_deficiency_page.dart';
import 'disease_care/white_spot_page.dart';

class ScanScreen extends StatefulWidget {
  final int refreshToken;

  const ScanScreen({super.key, this.refreshToken = 0});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  List<Lahan> _lahans = [];
  bool _isLoadingLahan = true;
  String? _lahanError;

  int? _selectedLahanId;
  File? _image;
  File? _lastDetectionImage;
  final TextEditingController _catatanController = TextEditingController();
  bool _isSubmitting = false;
  Map<String, dynamic>? _lastDetectionResult;
  String? _lastDetectionWarning;

  final ImagePicker _picker = ImagePicker();

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadLahan();
  }

  @override
  void didUpdateWidget(covariant ScanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _loadLahan();
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  // ── Data ───────────────────────────────────────────────────────────────────
  Future<void> _loadLahan() async {
    if (!mounted) return;
    setState(() {
      _isLoadingLahan = true;
      _lahanError = null;
    });
    try {
      debugPrint('[ScanScreen] Memuat daftar lahan...');
      final list = await ApiService.getLahan();
      debugPrint('[ScanScreen] Lahan berhasil dimuat: ${list.length} item');
      if (!mounted) return;
      setState(() => _lahans = list);
    } catch (e) {
      debugPrint('[ScanScreen] Error memuat lahan: $e');
      if (!mounted) return;
      setState(() => _lahanError = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoadingLahan = false);
    }
  }

  // ── Image picker ───────────────────────────────────────────────────────────
  Future<void> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    } else {
      await Permission.photos.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1280,
      );
      if (picked == null) return;
      setState(() => _image = File(picked.path));
    } catch (e) {
      debugPrint('Error ambil gambar: $e');
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Pilih Sumber Foto',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.pop(context);
                await _requestPermission(ImageSource.camera);
                await _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                await _requestPermission(ImageSource.gallery);
                await _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (_selectedLahanId == null) {
      _showSnackBar('Pilih lahan terlebih dahulu', isError: true);
      return;
    }
    if (_image == null) {
      _showSnackBar('Upload foto tanaman terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await ApiService.createDeteksi(
        lahanId: _selectedLahanId!,
        gambar: _image!,
        catatan: _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
      );

      final aiPrediction = result['ai_prediction'] is Map
          ? Map<String, dynamic>.from(result['ai_prediction'] as Map)
          : <String, dynamic>{};
      final hasil =
          aiPrediction['prediction_class']?.toString() ??
          aiPrediction['hasil']?.toString() ??
          result['hasil']?.toString() ??
          'Tidak diketahui';

      final aiWarning = result['ai_warning']?.toString();
      final index = _getResultIndex(hasil);
      final diseaseKey = _resolveDiseaseKey(hasil);

      if (!mounted) return;

      setState(() {
        _lastDetectionImage = _image;
        _lastDetectionResult = {
          ...aiPrediction,
          'hasil': hasil,
          'index': index,
          'disease_key': diseaseKey,
        };
        _lastDetectionWarning = aiWarning;
      });

      _showSnackBar(
        aiWarning == null || aiWarning.isEmpty
            ? 'Deteksi berhasil: $hasil'
            : 'Deteksi tersimpan, namun AI offline. Hasil sementara: $hasil',
        isError: aiWarning != null && aiWarning.isNotEmpty,
      );
      // Reset form
      setState(() {
        _image = null;
        _selectedLahanId = null;
        _catatanController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface2,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                '🔬 Deteksi Penyakit Cabai',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload foto tanaman cabai untuk mendeteksi penyakit secara otomatis',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Konten utama
              if (_isLoadingLahan)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (_lahanError != null)
                _buildErrorState()
              else if (_lahans.isEmpty)
                _buildEmptyLahan()
              else ...[
                _buildLahanSection(),
                const SizedBox(height: 20),
                _buildUploadSection(),
                const SizedBox(height: 20),
                _buildCatatanSection(),
                if (_lastDetectionResult != null) ...[
                  const SizedBox(height: 20),
                  _buildDetectionResultSection(),
                ],
                const SizedBox(height: 20),
                _buildTipsSection(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Lahan kosong ───────────────────────────────────────────────────────────
  Widget _buildEmptyLahan() {
    return _card(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text('🌿', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Lahan Terdaftar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Silakan tambahkan lahan terlebih dahulu di halaman Beranda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _card(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Icon(Icons.error_outline, color: AppColors.danger, size: 36),
          const SizedBox(height: 12),
          Text(
            _lahanError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.danger, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadLahan,
            icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
            label: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Pilih Lahan ────────────────────────────────────────────────────────────
  Widget _buildLahanSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.map, 'Pilih Lahan'),
          const SizedBox(height: 4),
          const Text(
            'Pilih lahan yang akan dilakukan deteksi',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          ..._lahans.map((lahan) => _buildLahanOption(lahan)),
        ],
      ),
    );
  }

  Widget _buildLahanOption(Lahan lahan) {
    final isSelected = _selectedLahanId == lahan.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedLahanId = lahan.id),
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
            // Ikon daun
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
            // Info lahan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lahan.namaLahan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '📍 ${lahan.lokasi}'
                    '${lahan.panjang != null ? ' · ${lahan.panjang} m' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Centang
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

  // ── Upload Foto ────────────────────────────────────────────────────────────
  Widget _buildUploadSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.image, 'Upload Foto Tanaman'),
          const SizedBox(height: 16),
          _image == null ? _buildDropZone() : _buildPreview(),
        ],
      ),
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: _showPicker,
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

  Widget _buildPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _image!,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _image = null),
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
            onTap: _showPicker,
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

  // ── Catatan ────────────────────────────────────────────────────────────────
  Widget _buildCatatanSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 8),
              Text(
                'Catatan (Opsional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _catatanController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'cth: Daun mulai menguning sejak 3 hari lalu...',
              hintStyle: const TextStyle(
                color: AppColors.textLight,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.surface2,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tips ───────────────────────────────────────────────────────────────────
  Widget _buildTipsSection() {
    final lastResult = _lastDetectionResult;
    final resultLabel = lastResult?['hasil']?.toString() ?? 'Belum ada hasil';
    final index = lastResult?['index'] as int? ?? -1;
    final tips = _getTipsForResult(resultLabel);

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

  Widget _buildDetectionResultSection() {
    final result = _lastDetectionResult ?? <String, dynamic>{};
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
    final diseaseKey =
        result['disease_key']?.toString() ?? _resolveDiseaseKey(label);
    final diseaseInfo = diseaseCareLibrary[diseaseKey];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastDetectionImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                _lastDetectionImage!,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
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
            _buildDiseaseCareSummary(diseaseInfo),
          ],
          if (_lastDetectionWarning != null &&
              _lastDetectionWarning!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _lastDetectionWarning!,
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

  Widget _buildDiseaseCareSummary(DiseaseCareContent content) {
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
              onPressed: () {
                final page = _buildDiseaseDetailPage(content.id);
                if (page == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              },
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
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF92400E),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        ...topItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Color(0xFF92400E))),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildDiseaseDetailPage(String id) {
    switch (id) {
      case 'bacterial_spot':
        return const BacterialSpotPage();
      case 'cercospora_leaf_spot':
        return const CercosporaLeafSpotPage();
      case 'curl_virus':
        return const CurlVirusPage();
      case 'healthy_leaf':
        return const HealthyLeafPage();
      case 'nutrition_deficiency':
        return const NutritionDeficiencyPage();
      case 'white_spot':
        return const WhiteSpotPage();
      default:
        return null;
    }
  }

  List<String> _getTipsForResult(String label) {
    final diseaseKey = _resolveDiseaseKey(label);

    if (diseaseKey == 'healthy_leaf') {
      return const [
        'Pertahankan penyiraman rutin pagi atau sore.',
        'Lanjutkan pemupukan seimbang agar tanaman tetap kuat.',
        'Pantau daun dan batang setiap 2-3 hari untuk deteksi dini.',
        'Pastikan lahan memiliki drainase yang baik.',
      ];
    }

    if (diseaseKey == 'cercospora_leaf_spot') {
      return const [
        'Pangkas daun yang paling parah terserang.',
        'Hindari menyiram dari atas daun agar kelembapan tidak tinggi.',
        'Semprot fungisida sesuai anjuran jika gejala meluas.',
        'Bersihkan alat kerja setelah digunakan pada tanaman sakit.',
      ];
    }

    if (diseaseKey == 'curl_virus') {
      return const [
        'Periksa keberadaan kutu daun dan whitefly di sekitar tanaman.',
        'Gunakan perangkap kuning atau pengendalian hama terpadu.',
        'Cabut tanaman yang gejalanya sudah sangat parah.',
        'Jaga kebersihan gulma di sekitar lahan.',
      ];
    }

    if (diseaseKey == 'nutrition_deficiency') {
      return const [
        'Lakukan koreksi hara sesuai gejala dominan pada daun.',
        'Gunakan pupuk daun untuk pemulihan cepat gejala akut.',
        'Evaluasi pH tanah agar penyerapan unsur hara optimal.',
        'Pantau perkembangan daun baru setelah pemupukan korektif.',
      ];
    }

    if (diseaseKey == 'bacterial_spot') {
      return const [
        'Buang daun terinfeksi dan hindari kelembapan berlebih.',
        'Kurangi penyiraman dari atas daun untuk menekan penyebaran.',
        'Lakukan sanitasi alat dan area kerja secara rutin.',
        'Terapkan bakterisida sesuai anjuran jika gejala meningkat.',
      ];
    }

    if (diseaseKey == 'white_spot') {
      return const [
        'Amati bagian bawah daun untuk cek kemungkinan hama penyebab.',
        'Pangkas daun dengan bercak putih yang paling parah.',
        'Jaga sirkulasi udara agar daun tidak lembap terlalu lama.',
        'Lakukan penanganan sesuai diagnosis lanjutan bila gejala menetap.',
      ];
    }

    return const [
      'Ambil foto ulang dengan pencahayaan yang lebih baik.',
      'Fokuskan kamera pada bagian tanaman yang menunjukkan gejala.',
      'Gunakan fitur tips di aplikasi sebagai panduan perawatan umum.',
      'Kirim ulang deteksi setelah service AI stabil jika hasil belum jelas.',
    ];
  }

  int _getResultIndex(String label) {
    const diseaseOrder = <String>[
      'bacterial_spot',
      'cercospora_leaf_spot',
      'curl_virus',
      'healthy_leaf',
      'nutrition_deficiency',
      'white_spot',
    ];

    final key = _resolveDiseaseKey(label);
    final idx = diseaseOrder.indexOf(key);
    return idx >= 0 ? idx : -1;
  }

  String _resolveDiseaseKey(String label) {
    final normalized = label.toLowerCase();

    if (normalized.contains('bacterial spot') ||
        normalized.contains('bercak bakteri')) {
      return 'bacterial_spot';
    }

    if (normalized.contains('cercospora') ||
        normalized.contains('cecospora') ||
        normalized.contains('bercak daun') ||
        normalized.contains('leaf spot')) {
      return 'cercospora_leaf_spot';
    }

    if (normalized.contains('curl virus') ||
        normalized.contains('leaf curl') ||
        normalized.contains('keriting daun') ||
        normalized.contains('curl')) {
      return 'curl_virus';
    }

    if (normalized.contains('healthy leaf') ||
        normalized.contains('healthy') ||
        normalized.contains('sehat')) {
      return 'healthy_leaf';
    }

    if (normalized.contains('nutrition deficiency') ||
        normalized.contains('deficiency') ||
        normalized.contains('defisiensi')) {
      return 'nutrition_deficiency';
    }

    if (normalized.contains('white spot') ||
        normalized.contains('bercak putih')) {
      return 'white_spot';
    }

    return 'healthy_leaf';
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
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1E3A8A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Submit button ──────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submit,
        icon: _isSubmitting
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
          _isSubmitting ? 'Sedang Menganalisis...' : 'Mulai Deteksi Sekarang',
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
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
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
