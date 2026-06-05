import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/colors.dart';

import '../../core/widgets/dialogs/lahan_dialog.dart';
import '../../core/widgets/navigation/bottom_navbar.dart';

import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';

import '../../core/utils/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../lahan/lahan_model.dart';

import '../../features/tips/tips_screen.dart';
import '../../features/scan/scan_screen.dart';
import '../profile/profile_screen.dart';
import '../history/history_screen.dart';

import 'home_sections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  int _scanRefreshToken = 0;
  int _historyRefreshToken = 0;

  bool _isLoading = true;

  String _userName = 'Petani';

  List<Lahan> _lahans = [];

  int _totalDeteksi = 0;
  int _tanamanSehat = 0;
  int _perluPerhatian = 0;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _loadData();
  }

  Future<void> _loadData() async {
    final lahans = await ApiService.getLahan();

    final deteksis = await ApiService.getDeteksis();

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(tokenKey);

    String userName = 'Petani';

    if (token != null) {
      final me = await AuthService.getMe(token);

      if (me['success'] == true) {
        userName = me['user']['name'];
      }
    }

    final sehat = deteksis
        .where((e) => e['hasil'].toString().toLowerCase().trim() == 'sehat')
        .length;

    final sakit = deteksis
        .where((e) => e['hasil'].toString().toLowerCase().trim() != 'sehat')
        .length;

    setState(() {
      _userName = userName;

      _lahans = lahans;

      _totalDeteksi = deteksis.length;

      _tanamanSehat = sehat;

      _perluPerhatian = sakit;

      _isLoading = false;
    });
  }

  void _refreshScanScreen() {
    setState(() {
      _scanRefreshToken++;
    });
  }

  Future<void> _handleDetectionCompleted() async {
    if (!mounted) return;
    setState(() {
      _historyRefreshToken++;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            SvgPicture.asset('assets/images/cabai.svg', height: 28),
            const SizedBox(width: 8),
            const Text('Cabaiku'),
          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),

          ScanScreen(
            refreshToken: _scanRefreshToken,
            onDetectionCompleted: _handleDetectionCompleted,
          ),

          const TipsScreen(),

          HistoryScreen(refreshToken: _historyRefreshToken),

          const ProfileScreen(),
        ],
      ),

      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            _refreshScanScreen();
          }
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeSections.buildHeader(
            context: context,
            userName: _userName,
            onDetectTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),

          HomeSections.buildStats(
            isLoading: _isLoading,
            totalDeteksi: _totalDeteksi,
            tanamanSehat: _tanamanSehat,
            perluPerhatian: _perluPerhatian,
            onScanTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            onTipsTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),

          const SizedBox(height: 24),

          HomeSections.buildLahanSection(
            lahans: _lahans,
            isLoading: _isLoading,
            onRefresh: _loadData,
            onTambah: () {
              showDialog(
                context: context,
                builder: (_) => LahanDialog(onSuccess: _loadData),
              );
            },
          ),
        ],
      ),
    );
  }
}
