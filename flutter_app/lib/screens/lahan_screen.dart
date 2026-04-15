import 'package:flutter/material.dart';

class LahanScreen extends StatefulWidget {
  const LahanScreen({super.key});

  @override
  State<LahanScreen> createState() => _LahanScreenState();
}

class _LahanScreenState extends State<LahanScreen> {
  Map<String, String>? _selectedLahan;
  TextEditingController _searchController = TextEditingController();
  String _selectedStatus = "Semua";

  final List<Map<String, String>> _lahanData = [
    {
      "nama": "Lahan Cabai 1",
      "ukuran": "5x10 m",
      "jenis": "Cabai",
      "status": "Sehat",
      "tanggal": "10 Maret 2026",
      "foto": "https://images.unsplash.com/photo-plant1",
    },
    {
      "nama": "Lahan Cabai 2",
      "ukuran": "4x8 m",
      "jenis": "Cabai",
      "status": "Ada Hama",
      "tanggal": "8 Maret 2026",
      "foto": "https://images.unsplash.com/photo-plant2",
    },
    {
      "nama": "Lahan Tomat",
      "ukuran": "6x12 m",
      "jenis": "Tomat",
      "status": "Panen",
      "tanggal": "5 Maret 2026",
      "foto": "https://images.unsplash.com/photo-plant3",
    },
  ];

  List<Map<String, String>> _filteredLahan = [];

  @override
  void initState() {
    super.initState();
    _filteredLahan = _lahanData;
  }

  void _filterLahan() {
    final query = _searchController.text.toLowerCase();
    final results = _lahanData.where((lahan) {
      final matchSearch = lahan['nama']!.toLowerCase().contains(query) ||
          lahan['jenis']!.toLowerCase().contains(query);
      final matchStatus = _selectedStatus == "Semua" || lahan['status'] == _selectedStatus;
      return matchSearch && matchStatus;
    }).toList();

    setState(() {
      _filteredLahan = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedLahan != null ? _buildDetail() : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return SingleChildScrollView(
      key: const ValueKey('list'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lahan Anda",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Kelola semua lahan pertanian Anda di sini",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Search
          TextField(
            controller: _searchController,
            onChanged: (value) => _filterLahan(),
            decoration: InputDecoration(
              hintText: "Cari nama lahan atau jenis tanaman...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Status
          Wrap(
            spacing: 8,
            children: ["Semua", "Sehat", "Ada Hama", "Panen"].map((status) {
              final isActive = _selectedStatus == status;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                  _filterLahan();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? Colors.green : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Column(
            children: _filteredLahan.map((lahan) => _lahanCard(lahan)).toList(),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _lahanCard(Map<String, String> lahan) {
    return GestureDetector(
      onTap: () => setState(() => _selectedLahan = lahan),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lahan['nama']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text("Ukuran: ${lahan['ukuran']}"),
              Text("Jenis: ${lahan['jenis']}"),
              _statusBadge(lahan['status']!),
              const SizedBox(height: 6),
              Text("Tanggal Tanam: ${lahan['tanggal']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case "Sehat":
        color = Colors.green;
        break;
      case "Ada Hama":
        color = Colors.orange;
        break;
      case "Panen":
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDetail() {
    final lahan = _selectedLahan!;
    return SingleChildScrollView(
      key: const ValueKey('detail'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedLahan = null),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: Colors.green),
                SizedBox(width: 4),
                Text("Kembali", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(lahan['foto']!, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(lahan['nama']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Ukuran: ${lahan['ukuran']}"),
          Text("Jenis Tanaman: ${lahan['jenis']}"),
          _statusBadge(lahan['status']!),
          Text("Tanggal Tanam: ${lahan['tanggal']}"),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text("Edit Lahan")),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lahanData.remove(lahan);
                _selectedLahan = null;
                _filterLahan();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus Lahan"),
          ),
        ],
      ),
    );
  }
}