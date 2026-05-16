import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../widgets/cards/welcome_card.dart';
import '../widgets/cards/stat_card.dart';
import '../widgets/cards/menu_card.dart';
import '../widgets/cards/lahan_card.dart';
import '../widgets/dialogs/lahan_dialog.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../models/lahan.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'tips_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late Future<List<Lahan>> _lahanFuture;
  int _scanRefreshToken = 0;
  String _userName = 'Petani';
  bool _isLoadingStats = true;
  int _totalDeteksi = 0;
  int _tanamanSehat = 0;
  int _perluPerhatian = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _lahanFuture = ApiService.getLahan();
    _loadUserName();
    _loadDetectionStats();
  }

  Future<void> _loadDetectionStats() async {
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final deteksis = await ApiService.getDeteksis();
      if (!mounted) return;

      final sehatCount = deteksis.where(_isHealthyResult).length;
      final total = deteksis.length;

      setState(() {
        _totalDeteksi = total;
        _tanamanSehat = sehatCount;
        _perluPerhatian = total - sehatCount;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _totalDeteksi = 0;
        _tanamanSehat = 0;
        _perluPerhatian = 0;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
    }
  }

  bool _isHealthyResult(Map<String, dynamic> item) {
    final hasil = (item['hasil'] ?? '').toString().toLowerCase();
    return hasil.contains('sehat') || hasil.contains('healthy');
  }

  Future<void> _loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null || token.isEmpty) {
        return;
      }

      final meResult = await AuthService.getMe(token);
      if (meResult['success'] != true) {
        return;
      }

      final userData = Map<String, dynamic>.from(meResult['user'] as Map);
      final name = (userData['name'] ?? '').toString().trim();

      if (!mounted || name.isEmpty) {
        return;
      }

      setState(() {
        _userName = name;
      });
    } catch (_) {
      // Keep default greeting when user data is unavailable.
    }
  }

  // Menggunakan getter agar halaman selalu sinkron dengan state terbaru
  List<Widget> get _pages => [
    _buildBerandaContent(), // Index 0
    ScanScreen(refreshToken: _scanRefreshToken), // Index 1
    const TipsScreen(), // Index 2
    const HistoryScreen(), // Index 3
    const ProfileScreen(), // Index 4
  ];

  void _refreshLahan() {
    setState(() {
      _lahanFuture = ApiService.getLahan();
    });
  }

  void _refreshScanScreen() {
    setState(() {
      _scanRefreshToken++;
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Cabaiku",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol Keluar yang berfungsi
          TextButton.icon(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout, color: Colors.white, size: 16),
            label: const Text(
              "Keluar",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // IndexedStack menjaga posisi scroll setiap halaman
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            _loadDetectionStats();
          }
          if (index == 1) {
            _refreshScanScreen();
          }
        },
      ),
    );
  }

  // --- KONTEN HALAMAN BERANDA (INDEX 0) ---
  Widget _buildBerandaContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: WelcomeCard(
              userName: _userName,
              onDetectTap: () {
                setState(() => _currentIndex = 1);
                _refreshScanScreen();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                StatCard(
                  icon: Icons.camera_alt,
                  iconColor: Colors.blue,
                  value: _isLoadingStats ? '...' : _totalDeteksi.toString(),
                  label: 'Total Deteksi',
                ),
                StatCard(
                  icon: Icons.check_circle,
                  iconColor: AppColors.primary,
                  value: _isLoadingStats ? '...' : _tanamanSehat.toString(),
                  label: 'Tanaman Sehat',
                ),
                StatCard(
                  icon: Icons.error,
                  iconColor: Colors.orange,
                  value: _isLoadingStats ? '...' : _perluPerhatian.toString(),
                  label: 'Perlu Perhatian',
                ),

                const SizedBox(height: 16),

                // Menu Deteksi: Mengarahkan ke Tab Scan (Index 1)
                MenuCard(
                  icon: Icons.camera_alt_outlined,
                  iconColor: AppColors.primary,
                  title: "Deteksi Penyakit",
                  subtitle: "Scan tanaman cabai Anda",
                  onTap: () {
                    setState(() => _currentIndex = 1);
                  },
                ),

                // Menu Tips: Mengarahkan ke Tab Tips (Index 2)
                MenuCard(
                  icon: Icons.article_outlined,
                  iconColor: Colors.blueAccent,
                  title: "Tips Perawatan",
                  subtitle: "Artikel & panduan lengkap",
                  onTap: () {
                    setState(() => _currentIndex = 2);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- SECTION LAHAN ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "🌾 Lahan Saya",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          LahanDialog(onSuccess: _refreshLahan),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<Lahan>>(
              future: _lahanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  final errorText =
                      snapshot.error?.toString().replaceAll(
                        'Exception: ',
                        '',
                      ) ??
                      'Terjadi kesalahan tidak diketahui';

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Gagal memuat data",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _refreshLahan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            "Coba Lagi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final lahans = snapshot.data ?? [];

                if (lahans.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.border,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.landscape_outlined,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum Ada Lahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tambahkan lahan pertama Anda untuk memulai",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  LahanDialog(onSuccess: _refreshLahan),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Tambah Lahan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: lahans
                      .map(
                        (lahan) =>
                            LahanCard(lahan: lahan, onRefresh: _refreshLahan),
                      )
                      .toList(),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Artikel Terbaru",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _currentIndex = 2);
                  },
                  child: const Text(
                    "Lihat Semua",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildArticleCard(
                  "Cara Mencegah Hama pada Tanaman Cabai",
                  "Tips efektif untuk melindungi tanaman cabai dari serangan hama...",
                  "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=500",
                ),
                _buildArticleCard(
                  "Pupuk Terbaik untuk Pertumbuhan Cabai",
                  "Rekomendasi jenis pupuk yang cocok untuk meningkatkan hasil panen...",
                  "https://images.unsplash.com/photo-1628352081506-83c43123ed6d?q=80&w=500",
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDailyTipsCard(),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String desc, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Color(0xFFD97706),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Tips Hari Ini",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pastikan tanaman cabai mendapat penyiraman teratur di pagi atau sore hari. Hindari penyiraman saat terik matahari untuk mencegah daun terbakar.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF78350F),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
