import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/lahan.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

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
  final TextEditingController _catatanController = TextEditingController();
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadLahan();
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
                child: const Icon(Icons.photo_library, color: AppColors.primary),
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
      await ApiService.createDeteksi(
        lahanId: _selectedLahanId!,
        gambar: _image!,
        catatan: _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
      );
      if (!mounted) return;
      _showSnackBar('Deteksi berhasil dikirim!');
      // Reset form
      setState(() {
        _image = null;
        _selectedLahanId = null;
        _catatanController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        e.toString().replaceAll('Exception: ', ''),
        isError: true,
      );
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
            label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              Icon(Icons.sticky_note_2_outlined,
                  size: 18, color: AppColors.textMuted),
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
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
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
          _tipItem('Ambil foto dengan pencahayaan yang cukup, hindari bayangan'),
          _tipItem('Fokuskan pada bagian tanaman yang menunjukkan gejala'),
          _tipItem('Pastikan foto tidak buram atau terlalu gelap'),
          _tipItem('Ambil dari jarak 20–30 cm untuk detail yang jelas'),
        ],
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
