import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/buttons/custom_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLightGreen,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.logoRed,
                  child: const Icon(Icons.local_fire_department, color: Colors.white, size: 35),
                ),
                const SizedBox(height: 16),
                const Text("Daftar Akun", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Bergabung dengan Komunitas Petani Cabai", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 24),
                
                _buildField("Nama Lengkap", "Masukkan nama lengkap"),
                _buildField("Email", "contoh@email.com"),
                _buildField("No. Telepon", "08xxxxxxxxxx"),
                _buildField("Password", "Minimal 6 karakter", isPassword: true),
                _buildField("Konfirmasi Password", "Masukkan ulang password", isPassword: true),
                
                const SizedBox(height: 16),

               CustomButton(
                  text: "Daftar", 
                  onPressed: () {
                    // Setelah daftar, biasanya langsung diarahkan ke Home
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? ", style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Masuk di sini", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.textFieldBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}