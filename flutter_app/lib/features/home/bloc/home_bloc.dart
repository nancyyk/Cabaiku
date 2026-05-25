import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/constants.dart';

import 'home_state.dart';

class HomeBloc extends ChangeNotifier {
  HomeState _state = HomeState.initial();

  HomeState get state => _state;

  Future<void> loadHomeData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString(tokenKey);

      String userName = 'Petani';

      if (token != null && token.isNotEmpty) {
        final meResult = await AuthService.getMe(token);

        if (meResult['success'] == true) {
          final userData = Map<String, dynamic>.from(meResult['user'] as Map);

          final name = (userData['name'] ?? '').toString().trim();

          if (name.isNotEmpty) {
            userName = name;
          }
        }
      }

      final lahans = await ApiService.getLahan();

      final deteksis = await ApiService.getDeteksis();

      final sehatCount = deteksis.where(_isHealthyResult).length;

      _state = _state.copyWith(
        isLoading: false,
        userName: userName,
        lahans: lahans,
        totalDeteksi: deteksis.length,
        tanamanSehat: sehatCount,
        perluPerhatian: deteksis.length - sehatCount,
        error: null,
      );

      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());

      notifyListeners();
    }
  }

  Future<void> refreshLahan() async {
    try {
      final lahans = await ApiService.getLahan();

      _state = _state.copyWith(lahans: lahans);

      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(error: e.toString());

      notifyListeners();
    }
  }

  bool _isHealthyResult(dynamic item) {
    if (item is! Map<String, dynamic>) {
      return false;
    }

    final hasil = (item['hasil'] ?? '').toString().toLowerCase();

    return hasil.contains('sehat') || hasil.contains('healthy');
  }
}
