import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../lahan/lahan_model.dart';
import '../../core/services/api_service.dart';
import '../../features/disease_care/bacterial_spot_page.dart';
import '../../features/disease_care/cercospora_leaf_spot_page.dart';
import '../../features/disease_care/curl_virus_page.dart';
import '../../features/disease_care/disease_care_data.dart';
import '../../features/disease_care/healthy_leaf_page.dart';
import '../../features/disease_care/nutrition_deficiency_page.dart';
import '../../features/disease_care/white_spot_page.dart';
import '../../core/utils/colors.dart';
import 'bloc/scan_bloc.dart';
import 'scan_sections.dart';
import 'scan_styles.dart';

class ScanScreen extends StatefulWidget {
  final int refreshToken;
  final Future<void> Function()? onDetectionCompleted;

  const ScanScreen({
    super.key,
    this.refreshToken = 0,
    this.onDetectionCompleted,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  late ScanBloc _scanBloc;
  List<Lahan> _lahans = [];
  String? _lahanError;

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
    _scanBloc = ScanBloc();
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
      _scanBloc.setLoadingLahan(true);
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
      if (mounted) setState(() => _scanBloc.setLoadingLahan(false));
    }
  }

  // ── Image picker ───────────────────────────────────────────────────────────
  Future<bool> _requestPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();

      if (!status.isGranted && !status.isLimited) {
        status = await Permission.storage.request();
      }
    }

    return status.isGranted || status.isLimited;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1280,
      );
      if (picked == null) return;
      setState(() => _scanBloc.setImage(File(picked.path)));
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
                final hasPermission = await _requestPermission(
                  ImageSource.camera,
                );
                if (!hasPermission) return;
                if (!mounted) return;
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
                final hasPermission = await _requestPermission(
                  ImageSource.gallery,
                );
                if (!hasPermission) return;
                if (!mounted) return;
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
    if (_scanBloc.state.selectedLahanId == null) {
      _showSnackBar('Pilih lahan terlebih dahulu', isError: true);
      return;
    }
    if (_scanBloc.state.image == null) {
      _showSnackBar('Upload foto tanaman terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await ApiService.createDeteksi(
        lahanId: _scanBloc.state.selectedLahanId!,
        gambar: _scanBloc.state.image!,
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
      final detectedImage = _scanBloc.state.image;

      if (!mounted) return;

      setState(() {
        _lastDetectionImage = detectedImage;
        _lastDetectionResult = {
          ...aiPrediction,
          'hasil': hasil,
          'index': index,
          'disease_key': diseaseKey,
        };
        _lastDetectionWarning = aiWarning;
        _scanBloc.setImage(null);
        _scanBloc.setSelectedLahanId(null);
        _catatanController.clear();
      });

      _showSnackBar(
        aiWarning == null || aiWarning.isEmpty
            ? 'Deteksi berhasil: $hasil'
            : 'Deteksi tersimpan, namun AI offline. Hasil sementara: $hasil',
        isError: aiWarning != null && aiWarning.isNotEmpty,
      );
      await widget.onDetectionCompleted?.call();
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
                style: ScanStyles.headerTitle,
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload foto tanaman cabai untuk mendeteksi penyakit secara otomatis',
                style: ScanStyles.headerSubtitle,
              ),
              const SizedBox(height: 24),

              // Konten utama
              if (_scanBloc.state.isLoadingLahan)
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
                buildLahanSection(
                  lahans: _lahans,
                  selectedLahanId: _scanBloc.state.selectedLahanId,
                  onSelectLahan: (id) =>
                      setState(() => _scanBloc.setSelectedLahanId(id)),
                ),
                const SizedBox(height: 20),
                buildUploadSection(
                  image: _scanBloc.state.image,
                  onShowPicker: _showPicker,
                  onRemoveImage: () => setState(() => _scanBloc.setImage(null)),
                ),
                const SizedBox(height: 20),
                _buildCatatanSection(),
                if (_lastDetectionResult != null) ...[
                  const SizedBox(height: 20),
                  buildDetectionResultSection(
                    result: _lastDetectionResult ?? <String, dynamic>{},
                    lastDetectionImage: _lastDetectionImage,
                    lastDetectionWarning: _lastDetectionWarning,
                    diseaseInfo:
                        diseaseCareLibrary[_lastDetectionResult?['disease_key']
                                ?.toString() ??
                            _resolveDiseaseKey(
                              _lastDetectionResult?['hasil']?.toString() ??
                                  'Tidak diketahui',
                            )],
                    onDiseaseDetailPressed: (id) {
                      final page = _buildDiseaseDetailPage(id);
                      if (page == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => page),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                buildTipsSection(
                  resultLabel:
                      _lastDetectionResult?['hasil']?.toString() ??
                      'Belum ada hasil',
                  index: _lastDetectionResult?['index'] as int? ?? -1,
                  tips: _getTipsForResult(
                    _lastDetectionResult?['hasil']?.toString() ??
                        'Belum ada hasil',
                  ),
                ),
                const SizedBox(height: 24),
                buildSubmitButton(
                  isSubmitting: _isSubmitting,
                  onPressed: _submit,
                ),
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

  // ── Pilih Lahan dan Upload Foto moved to scan_sections.dart

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

  // ── Tips and result sections moved to scan_sections.dart

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

  // UI helpers moved to scan_sections.dart and scan_styles.dart
}
