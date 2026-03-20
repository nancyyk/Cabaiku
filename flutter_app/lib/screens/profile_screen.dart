import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // Data profil (Logika Anda)
  String _name = "Budi Santoso";
  String _email = "budi.santoso@email.com";
  String _phone = "081234567890";
  String _location = "Brebes, Jawa Tengah";
  String _landSize = "1.5 hektar";

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _landSizeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _name);
    _emailController = TextEditingController(text: _email);
    _phoneController = TextEditingController(text: _phone);
    _locationController = TextEditingController(text: _location);
    _landSizeController = TextEditingController(text: _landSize);
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

  void _saveProfile() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
      _location = _locationController.text;
      _landSize = _landSizeController.text;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu muda sesuai figma
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profil Saya",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Kelola informasi akun Anda",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Form Edit atau Tampilan Biasa
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

  // --- TAMPILAN VIEW PROFIL (Sesuai Figma) ---
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.primaryGreen,
            child: Text("BS", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Bergabung sejak Januari 2026", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("24", "Total Deteksi"),
              _buildStatItem("15", "Artikel Dibaca"),
              _buildStatItem("68", "Hari Aktif"),
            ],
          ),
          const Divider(height: 40),
          _buildInfoRow(Icons.person_outline, "Nama Lengkap", _name),
          _buildInfoRow(Icons.email_outlined, "Email", _email),
          _buildInfoRow(Icons.phone_android_outlined, "No. Telepon", _phone),
          _buildInfoRow(Icons.location_on_outlined, "Lokasi", _location),
          _buildInfoRow(Icons.landscape_outlined, "Luas Lahan", _landSize),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1220), // Tombol Hitam Figma
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN EDIT FORM (Sesuai Figma) ---
  Widget _buildEditForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildTextField("Nama Lengkap", _nameController),
          _buildTextField("Email", _emailController),
          _buildTextField("No. Telepon", _phoneController),
          _buildTextField("Lokasi", _locationController),
          _buildTextField("Luas Lahan", _landSizeController),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
                  label: const Text("Simpan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
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
                  label: const Text("Batal", style: TextStyle(color: Colors.black)),
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

  // --- SUB-WIDGETS ---

  Widget _buildPencapaianSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pencapaian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text("Badge yang telah Anda dapatkan", style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 16),
        _buildBadgeCard("Petani Pemula", "Melakukan 5 deteksi pertama", true),
        _buildBadgeCard("Rajin Belajar", "Membaca 10 artikel", true),
        _buildBadgeCard("Ahli Deteksi", "Melakukan 50 deteksi", false),
        _buildBadgeCard("Petani Berdedikasi", "Aktif selama 100 hari", false),
      ],
    );
  }

  Widget _buildPengaturanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pengaturan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildSettingItem("Ubah Password", Colors.black),
        _buildSettingItem("Notifikasi", Colors.black),
        _buildSettingItem("Bahasa", Colors.black),
        _buildSettingItem("Hapus Akun", Colors.red),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
        border: Border.all(color: earned ? Colors.green.withOpacity(0.3) : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: earned ? Colors.black : Colors.grey)),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          if (earned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
              child: const Text("Didapat", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
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
          child: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
      ],
    );
  }
}