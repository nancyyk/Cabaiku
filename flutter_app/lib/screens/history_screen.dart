import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // 1. Variabel untuk menyimpan data yang sedang diklik (Detail)
  Map<String, dynamic>? _selectedData;

  List<Map<String, dynamic>> historyData = [
    {
      "status": "Sehat",
      "tingkat": "Ringan",
      "akurasi": "95%",
      "tanggal": "11 Maret 2026",
      "jam": "09:30",
      "isHealthy": true,
    },
    {
      "status": "Bercak Daun (Leaf Spot)",
      "tingkat": "Sedang",
      "akurasi": "87%",
      "tanggal": "10 Maret 2026",
      "jam": "14:15",
      "isHealthy": false,
    },
    {
      "status": "Keriting Daun (Leaf Curl)",
      "tingkat": "Sedang",
      "akurasi": "84%",
      "tanggal": "8 Maret 2026",
      "jam": "16:20",
      "isHealthy": false,
    },
  ];

  void _deleteItem(int index) {
    setState(() {
      historyData.removeAt(index);
      _selectedData = null; // Tutup detail setelah hapus
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. LOGIKA KONDISIONAL: Jika _selectedData tidak null, tampilkan Detail.
    if (_selectedData != null) {
      return _buildDetailView(_selectedData!);
    }

    // Jika null, tampilkan Daftar Riwayat Utama
    return _buildListView();
  }

  // Daftar riwayat
  Widget _buildListView() {
    int totalDeteksi = historyData.length;
    int tanamanSehat = historyData
        .where((item) => item['isHealthy'] == true)
        .length;
    int terdeteksiPenyakit = totalDeteksi - tanamanSehat;

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Riwayat Deteksi",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Lihat semua hasil deteksi penyakit tanaman cabai Anda",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _buildStatCard(
              totalDeteksi.toString(),
              "Total Deteksi",
              Colors.black,
            ),
            _buildStatCard(
              tanamanSehat.toString(),
              "Tanaman Sehat",
              Colors.green,
              icon: Icons.check_circle_outline,
            ),
            _buildStatCard(
              terdeteksiPenyakit.toString(),
              "Terdeteksi Penyakit",
              Colors.red,
              icon: Icons.error_outline,
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final item = historyData[index];
                return InkWell(
                  onTap: () => setState(
                    () => _selectedData = item,
                  ), // Set data untuk pindah ke detail
                  child: _buildHistoryItem(index, item),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Detail riwayat
  Widget _buildDetailView(Map<String, dynamic> data) {
    bool isHealthy = data['isHealthy'];

    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _selectedData = null), // Kembali ke daftar
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Kembali ke Riwayat",
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                        data['status'],
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
                Row(
                  children: [
                    _buildBadge(
                      data['tingkat'],
                      isHealthy ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    _buildBadge("Akurasi: ${data['akurasi']}", Colors.blueGrey),
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
                      data['tanggal'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      data['jam'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                    "Hasil deteksi ini disimpan untuk referensi Anda. Untuk deteksi baru, silakan kunjungi halaman Deteksi.",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      int idx = historyData.indexOf(data);
                      _deleteItem(idx);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: const Text(
                      "Hapus Riwayat Ini",
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
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
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

  Widget _buildHistoryItem(int index, Map<String, dynamic> item) {
  bool isHealthy = item['isHealthy'];

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
        // 🔥 BARIS ATAS (ICON + STATUS + DELETE)
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
                item['status'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            // 🔥 tombol hapus kecil (kanan)
            GestureDetector(
              onTap: () => _deleteItem(index),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 🔥 BADGE (TINGKAT + AKURASI)
        Row(
          children: [
            _buildBadge(
              item['tingkat'],
              isHealthy ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            _buildBadge("${item['akurasi']} akurat", const Color.fromARGB(255, 83, 95, 105)),
          ],
        ),

        const SizedBox(height: 10),

        // 🔥 TANGGAL + JAM
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              item['tanggal'],
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.access_time, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              item['jam'],
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
}
