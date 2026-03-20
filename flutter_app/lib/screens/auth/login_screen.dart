import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/buttons/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLightGreen,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.logoRed,
                  child: const Icon(Icons.local_fire_department, color: Colors.white, size: 35),
                ),
                const SizedBox(height: 16),
                const Text("Cabaiku", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Aplikasi Pintar untuk Petani Cabai", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 24),
                
                // Form
                _buildTextField("Email atau No. Telepon", "Masukkan email atau no. telepon"),
                const SizedBox(height: 16),
                _buildTextField("Password", "Masukkan password", isPassword: true),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Lupa Password?", style: TextStyle(color: AppColors.primaryGreen, fontSize: 12)),
                  ),
                ),
                
                // Login Button
               CustomButton(
                  text: "Masuk", 
                  onPressed: () {
                      // Pindah ke halaman Home dan hapus history route sebelumnya
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? ", style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: const Text("Daftar Sekarang", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
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

  Widget _buildTextField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.textFieldBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}