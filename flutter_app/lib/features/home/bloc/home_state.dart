import '../../lahan/lahan_model.dart';

class HomeState {
  final bool isLoading;
  final String userName;
  final List<Lahan> lahans;

  final int totalDeteksi;
  final int tanamanSehat;
  final int perluPerhatian;

  final String? error;

  HomeState({
    required this.isLoading,
    required this.userName,
    required this.lahans,
    required this.totalDeteksi,
    required this.tanamanSehat,
    required this.perluPerhatian,
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      isLoading: false,
      userName: 'Petani',
      lahans: [],
      totalDeteksi: 0,
      tanamanSehat: 0,
      perluPerhatian: 0,
      error: null,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    String? userName,
    List<Lahan>? lahans,
    int? totalDeteksi,
    int? tanamanSehat,
    int? perluPerhatian,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      lahans: lahans ?? this.lahans,
      totalDeteksi: totalDeteksi ?? this.totalDeteksi,
      tanamanSehat: tanamanSehat ?? this.tanamanSehat,
      perluPerhatian: perluPerhatian ?? this.perluPerhatian,
      error: error,
    );
  }
}
