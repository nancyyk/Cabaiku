import 'package:flutter/material.dart';

import '../lahan/lahan_model.dart';

import '../../core/utils/colors.dart';

import '../../core/widgets/cards/welcome_card.dart';
import '../../core/widgets/cards/stat_card.dart';
import '../../core/widgets/cards/menu_card.dart';
import '../../core/widgets/cards/lahan_card.dart';

import 'home_styles.dart';

class HomeSections {
  static Widget buildHeader({
    required BuildContext context,
    required String userName,
    required VoidCallback onDetectTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: WelcomeCard(userName: userName, onDetectTap: onDetectTap),
    );
  }

  static Widget buildStats({
    required bool isLoading,
    required int totalDeteksi,
    required int tanamanSehat,
    required int perluPerhatian,
    required VoidCallback onScanTap,
    required VoidCallback onTipsTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          StatCard(
            icon: Icons.camera_alt,
            iconColor: Colors.blue,
            value: isLoading ? '...' : totalDeteksi.toString(),
            label: 'Total Deteksi',
          ),

          StatCard(
            icon: Icons.check_circle,
            iconColor: AppColors.primary,
            value: isLoading ? '...' : tanamanSehat.toString(),
            label: 'Tanaman Sehat',
          ),

          StatCard(
            icon: Icons.error,
            iconColor: Colors.orange,
            value: isLoading ? '...' : perluPerhatian.toString(),
            label: 'Perlu Perhatian',
          ),

          const SizedBox(height: 16),

          MenuCard(
            icon: Icons.camera_alt_outlined,
            iconColor: AppColors.primary,
            title: "Deteksi Penyakit",
            subtitle: "Scan tanaman cabai Anda",
            onTap: onScanTap,
          ),

          MenuCard(
            icon: Icons.article_outlined,
            iconColor: Colors.blueAccent,
            title: "Tips Perawatan",
            subtitle: "Artikel & panduan lengkap",
            onTap: onTipsTap,
          ),
        ],
      ),
    );
  }

  static Widget buildLahanSection({
    required List<Lahan> lahans,
    required bool isLoading,
    required VoidCallback onRefresh,
    required VoidCallback onTambah,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("🌾 Lahan Saya", style: HomeStyles.titleStyle),
              ElevatedButton.icon(
                onPressed: onTambah,
                icon: const Icon(Icons.add),
                label: const Text("Tambah"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (lahans.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text("Belum Ada Lahan"),
              ),
            )
          else
            Column(
              children: lahans
                  .map((lahan) => LahanCard(lahan: lahan, onRefresh: onRefresh))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
