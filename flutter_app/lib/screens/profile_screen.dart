import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lahan.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;

  String _name = '-';
  String _email = '-';
  String _phone = '-';
  String _location = '-';
  String _landSize = '-';
  String _joinedAtText = 'Bergabung sejak -';

  int _totalLahan = 0;
  double _totalLuas = 0;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _landSizeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _landSizeController = TextEditingController();
    _loadProfileFromApi();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _landSizeController.dispose();
    super.dispose();
  }

  String _joinText(dynamic createdAt) {
    if (createdAt == null) return 'Bergabung sejak -';
    final date = DateTime.tryParse(createdAt.toString());
    if (date == null) return 'Bergabung sejak -';
    final bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return 'Bergabung sejak ${bulan[date.month - 1]} ${date.year}';
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Future<void> _loadProfileFromApi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null || token.isEmpty) {
        throw Exception('Sesi login tidak ditemukan. Silakan login ulang.');
      }

      final meResult = await AuthService.getMe(token);
      if (meResult['success'] != true) {
        throw Exception(meResult['message']?.toString() ?? 'Gagal memuat profil');
      }

      final userData = Map<String, dynamic>.from(meResult['user'] as Map);
      final List<Lahan> lahanList = await ApiService.getLahan();
      // Hitung total luas dari panjang × lebar (dalam m²), konversi ke hektar
      final totalLuasM2 = lahanList.fold<double>(
        0,
        (sum, item) => sum + ((item.panjang ?? 0) * (item.lebar ?? 0)),
      );
      final totalLuas = totalLuasM2 / 10000;

      final name = (userData['name'] ?? '-').toString();
      final email = (userData['email'] ?? '-').toString();
      final phone = (userData['phone'] ?? '-').toString();
      final location = (userData['location'] ?? '-').toString();
      final landSize = '${totalLuas.toStringAsFixed(2)} hektar';

      if (!mounted) return;
      setState(() {
        _name = name;
        _email = email;
        _phone = phone;
        _location = location;
        _totalLahan = lahanList.length;
        _totalLuas = totalLuas;
        _landSize = landSize;
        _joinedAtText = _joinText(userData['created_at']);

        _nameController.text = name;
        _emailController.text = email;
        _phoneController.text = phone;
        _locationController.text = location;
        _landSizeController.text = landSize;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _saveProfile() {
    setState(() {
      _name = _nameController.text.trim().isEmpty ? _name : _nameController.text.trim();
      _email = _emailController.text.trim().isEmpty ? _email : _emailController.text.trim();
      _phone = _phoneController.text.trim().isEmpty ? _phone : _phoneController.text.trim();
      _location = _locationController.text.trim().isEmpty ? _location : _locationController.text.trim();
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan lokal tersimpan. Sinkron API profil belum diaktifkan.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.danger, size: 34),
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadProfileFromApi,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profil Saya', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Kelola informasi akun Anda', style: TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
                IconButton(
                  onPressed: _loadProfileFromApi,
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _isEditing ? _buildEditForm() : _buildProfileCard(),
            const SizedBox(height: 24),
            if (!_isEditing) ...[
              _buildPencapaianSection(),
              const SizedBox(height: 24),
              _buildPengaturanSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.primary,
            child: Text(
              _initials(_name),
              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(_joinedAtText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(_totalLahan.toString(), 'Total Lahan'),
              _buildStatItem(_totalLuas.toStringAsFixed(2), 'Total Ha'),
              _buildStatItem(_phone == '-' ? 'Belum' : 'Ada', 'No. Telepon'),
            ],
          ),
          const Divider(height: 40),
          _buildInfoRow(Icons.person_outline, 'Nama Lengkap', _name),
          _buildInfoRow(Icons.email_outlined, 'Email', _email),
          _buildInfoRow(Icons.phone_android_outlined, 'No. Telepon', _phone),
          _buildInfoRow(Icons.location_on_outlined, 'Lokasi', _location),
          _buildInfoRow(Icons.landscape_outlined, 'Luas Lahan', _landSize),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1220),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildTextField('Nama Lengkap', _nameController),
          _buildTextField('Email', _emailController),
          _buildTextField('No. Telepon', _phoneController),
          _buildTextField('Lokasi', _locationController),
          _buildTextField('Luas Lahan', _landSizeController),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
                  label: const Text('Simpan', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditing = false),
                  icon: const Icon(Icons.close, size: 18, color: Colors.black),
                  label: const Text('Batal', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPencapaianSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pencapaian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('Badge yang telah Anda dapatkan', style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 16),
        _buildBadgeCard('Petani Pemula', 'Melakukan 5 deteksi pertama', true),
        _buildBadgeCard('Rajin Belajar', 'Membaca 10 artikel', true),
        _buildBadgeCard('Ahli Deteksi', 'Melakukan 50 deteksi', false),
        _buildBadgeCard('Petani Berdedikasi', 'Aktif selama 100 hari', false),
      ],
    );
  }

  Widget _buildPengaturanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pengaturan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSettingItem('Ubah Password', Colors.black),
        _buildSettingItem('Notifikasi', Colors.black),
        _buildSettingItem('Bahasa', Colors.black),
        _buildSettingItem('Hapus Akun', Colors.red),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[400]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String title, String desc, bool earned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: earned ? const Color(0xFFF0FFF4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? Colors.green.withValues(alpha: 0.3) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: earned ? Colors.black : Colors.grey),
                ),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          if (earned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Didapat',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, Color textColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
