import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lahan/lahan_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/constants.dart';

import 'profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc() : super(ProfileState.initial());

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

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null || token.isEmpty) {
        throw Exception('Sesi login tidak ditemukan. Silakan login ulang.');
      }

      final meResult = await AuthService.getMe(token);
      if (meResult['success'] != true) {
        throw Exception(
          meResult['message']?.toString() ?? 'Gagal memuat profil',
        );
      }

      final userData = Map<String, dynamic>.from(meResult['user'] as Map);
      final List<Lahan> lahanList = await ApiService.getLahan();

      final totalLuasM2 = lahanList.fold<double>(
        0,
        (sum, item) => sum + ((item.panjang ?? 0) * (item.lebar ?? 0)),
      );

      final totalLuas = totalLuasM2 / 10000;

      emit(
        state.copyWith(
          isLoading: false,
          name: (userData['name'] ?? '-').toString(),
          email: (userData['email'] ?? '-').toString(),
          phone: (userData['phone'] ?? '-').toString(),
          location: (userData['location'] ?? '-').toString(),
          totalLahan: lahanList.length,
          totalLuas: totalLuas,
          landSize: '${totalLuas.toStringAsFixed(2)} hektar',
          joinedAtText: _joinText(userData['created_at']),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void toggleEdit(bool value) {
    emit(state.copyWith(isEditing: value));
  }

  void saveProfile({
    required String name,
    required String email,
    required String phone,
    required String location,
  }) {
    emit(
      state.copyWith(
        name: name.isEmpty ? state.name : name,
        email: email.isEmpty ? state.email : email,
        phone: phone.isEmpty ? state.phone : phone,
        location: location.isEmpty ? state.location : location,
        isEditing: false,
      ),
    );
  }
}
