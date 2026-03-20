import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/cards/welcome_card.dart';
import '../widgets/cards/stat_card.dart';
import '../widgets/cards/menu_card.dart';
import '../widgets/navigation/bottom_navbar.dart';
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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Menggunakan getter agar halaman selalu sinkron dengan state terbaru
  List<Widget> get _pages => [
    _buildBerandaContent(), // Index 0
    const ScanScreen(), // Index 1
    const TipsScreen(), // Index 2
    const HistoryScreen(), // Index 3
    const ProfileScreen(), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Cabaiku",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol Keluar yang berfungsi
          TextButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
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
              onDetectTap: () {
                setState(() => _currentIndex = 1);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const StatCard(
                  icon: Icons.camera_alt,
                  iconColor: Colors.blue,
                  value: "24",
                  label: "Total Deteksi",
                ),
                const StatCard(
                  icon: Icons.check_circle,
                  iconColor: AppColors.primaryGreen,
                  value: "18",
                  label: "Tanaman Sehat",
                ),
                const StatCard(
                  icon: Icons.error,
                  iconColor: Colors.orange,
                  value: "6",
                  label: "Perlu Perhatian",
                ),

                const SizedBox(height: 16),

                // Menu Deteksi: Mengarahkan ke Tab Scan (Index 1)
                MenuCard(
                  icon: Icons.camera_alt_outlined,
                  iconColor: Colors.redAccent,
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
        color: const Color(0xFFF1FFF1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.green, size: 24),
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
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pastikan tanaman cabai mendapat penyiraman teratur di pagi atau sore hari. Hindari penyiraman saat terik matahari untuk mencegah daun terbakar..",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green,
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
