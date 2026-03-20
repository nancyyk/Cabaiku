import 'package:flutter/material.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  bool _isShowingDetail = false;
  Map<String, String>? _selectedArticle;

  TextEditingController _searchController = TextEditingController();

  String _selectedCategory = "Semua";

  final List<Map<String, String>> _articles = [
    {
      "title": "Cara Mencegah Hama pada Tanaman Cabai",
      "desc":
          "Hama merupakan salah satu musuh utama petani cabai. Pelajari cara efektif untuk mencegah dan mengendalikan...",
      "image":
          "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=500",
      "category": "Hama & Penyakit",
      "date": "10 Maret 2026",
      "time": "5 menit",
      "content":
          "Hama pada tanaman cabai bisa menyebabkan kerugian besar. Gunakan pestisida alami, lakukan pengecekan rutin, dan jaga kebersihan lahan untuk mencegah serangan hama.",
    },
    {
      "title": "Sistem Pengairan yang Efisien",
      "desc":
          "Air adalah kunci pertumbuhan cabai. Pelajari teknik pengairan yang tepat...",
      "image":
          "https://images.unsplash.com/photo-1628352081506-83c43123ed6d?q=80&w=500",
      "category": "Perawatan",
      "date": "4 Maret 2026",
      "time": "4 menit",
      "content":
          "Gunakan irigasi tetes dan lakukan penyiraman pagi atau sore hari agar hasil optimal.",
    },
  ];

  List<Map<String, String>> _filteredArticles = [];

  @override
  void initState() {
    super.initState();
    _filteredArticles = _articles;
  }

  void _filterArticles() {
    final query = _searchController.text.toLowerCase();

    final results = _articles.where((article) {
      final title = article['title']!.toLowerCase();
      final desc = article['desc']!.toLowerCase();
      final category = article['category']!;

      final matchSearch =
          title.contains(query) || desc.contains(query);

      final matchCategory = _selectedCategory == "Semua" ||
          category == _selectedCategory;

      return matchSearch && matchCategory;
    }).toList();

    setState(() {
      _filteredArticles = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isShowingDetail ? _buildDetail() : _buildList(),
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
            "Tips & Artikel",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Panduan lengkap merawat dan\nmembudidayakan tanaman cabai",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _searchController,
            onChanged: (value) => _filterArticles(),
            decoration: InputDecoration(
              hintText: "Cari artikel, tips, atau panduan...",
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

          Wrap(
            spacing: 8,
            children: [
              _buildChip("Semua"),
              _buildChip("Hama & Penyakit"),
              _buildChip("Perawatan"),
              _buildChip("Panen"),
              _buildChip("Tips Budidaya"),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children: _filteredArticles.map((article) {
              return _card(article);
            }).toList(),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _card(Map<String, String> a) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedArticle = a;
          _isShowingDetail = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                a['image']!,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _badge(a['category']!),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        a['time']!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a['title']!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a['desc']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        a['date']!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.menu_book,
                              size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Baca Selengkapnya",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildChip(String label) {
    final isActive = _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
        _filterArticles();
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
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDetail() {
    final a = _selectedArticle!;
    return SingleChildScrollView(
      key: const ValueKey('detail'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _isShowingDetail = false;
              _selectedArticle = null;
            }),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, size: 18, color: Colors.green),
                SizedBox(width: 4),
                Text("Kembali",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(a['image']!),
          ),
          const SizedBox(height: 16),
          Text(a['title']!,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(a['content']!,
              style: const TextStyle(fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}