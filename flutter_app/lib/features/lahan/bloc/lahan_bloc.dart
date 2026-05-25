import 'package:flutter_bloc/flutter_bloc.dart';
import '../lahan_model.dart';
import 'lahan_state.dart';

class LahanBloc extends Cubit<LahanState> {
  LahanBloc() : super(LahanState.initial()) {
    loadDummy();
  }

  void loadDummy() {
    final data = [
      Lahan(
        id: 1,
        namaLahan: "Lahan Cabai 1",
        lokasi: "Sidoarjo",
        panjang: 10,
        lebar: 5,
        keterangan: "Sehat",
      ),
      Lahan(
        id: 2,
        namaLahan: "Lahan Cabai 2",
        lokasi: "Sidoarjo",
        panjang: 8,
        lebar: 4,
        keterangan: "Ada Hama",
      ),
      Lahan(
        id: 3,
        namaLahan: "Lahan Tomat",
        lokasi: "Sidoarjo",
        panjang: 12,
        lebar: 6,
        keterangan: "Panen",
      ),
    ];

    emit(state.copyWith(
      allLahan: data,
      filteredLahan: data,
    ));
  }

  void selectLahan(Lahan? lahan) {
    emit(state.copyWith(selectedLahan: lahan));
  }

  void changeStatus(String status) {
    _applyFilter(
      search: state.searchQuery,
      status: status,
    );
  }

  void search(String query) {
    _applyFilter(
      search: query,
      status: state.selectedStatus,
    );
  }

  void deleteLahan(Lahan lahan) {
    final updated = state.allLahan.where((e) => e.id != lahan.id).toList();

    emit(state.copyWith(
      allLahan: updated,
    ));

    _applyFilter(
      search: state.searchQuery,
      status: state.selectedStatus,
      list: updated,
    );
  }

  void _applyFilter({
    required String search,
    required String status,
    List<Lahan>? list,
  }) {
    final base = list ?? state.allLahan;

    final result = base.where((lahan) {
      final matchSearch = lahan.namaLahan.toLowerCase().contains(search.toLowerCase());

      final matchStatus =
          status == "Semua" || (lahan.keterangan ?? "") == status;

      return matchSearch && matchStatus;
    }).toList();

    emit(state.copyWith(
      filteredLahan: result,
      searchQuery: search,
      selectedStatus: status,
    ));
  }
}