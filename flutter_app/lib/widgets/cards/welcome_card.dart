import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class WelcomeCard extends StatelessWidget {
  final VoidCallback onDetectTap;

  const WelcomeCard({super.key, required this.onDetectTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selamat Datang, Petani! 👋",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Mari jaga kesehatan tanaman cabai Anda",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onDetectTap,
            icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryGreen, size: 20),
            label: const Text(
              "Deteksi Penyakit Sekarang",
              style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}