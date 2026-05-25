import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_bloc.dart';
import 'bloc/profile_state.dart';

import '../../core/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..loadProfile(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // isi controller saat pertama load
          _nameController.text = state.name;
          _emailController.text = state.email;
          _phoneController.text = state.phone;
          _locationController.text = state.location;
          _landSizeController.text = state.landSize;

          if (state.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Scaffold(body: Center(child: Text(state.errorMessage!)));
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
                          Text(
                            'Profil Saya',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Kelola informasi akun Anda',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () =>
                            context.read<ProfileBloc>().loadProfile(),
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  state.isEditing
                      ? _buildEditForm(context, state)
                      : _buildProfileCard(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.primary,
            child: Text(
              _initials(state.name),
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            state.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            state.joinedAtText,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(state.totalLahan.toString(), 'Total Lahan'),
              _buildStatItem(state.totalLuas.toStringAsFixed(2), 'Total Ha'),
              _buildStatItem(
                state.phone == '-' ? 'Belum' : 'Ada',
                'No. Telepon',
              ),
            ],
          ),
          const Divider(height: 40),
          _buildInfoRow(Icons.person, 'Nama', state.name),
          _buildInfoRow(Icons.email, 'Email', state.email),
          _buildInfoRow(Icons.phone, 'Telepon', state.phone),
          _buildInfoRow(Icons.location_on, 'Lokasi', state.location),
          _buildInfoRow(Icons.landscape, 'Luas Lahan', state.landSize),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<ProfileBloc>().toggleEdit(true),
            child: const Text('Edit Profil'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, ProfileState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildTextField('Nama', _nameController),
          _buildTextField('Email', _emailController),
          _buildTextField('Telepon', _phoneController),
          _buildTextField('Lokasi', _locationController),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().saveProfile(
                      name: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      location: _locationController.text,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.read<ProfileBloc>().toggleEdit(false),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
