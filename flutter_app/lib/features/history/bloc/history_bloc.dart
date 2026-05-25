import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import 'history_state.dart';

class HistoryBloc extends Cubit<HistoryState> {
  HistoryBloc() : super(HistoryState.initial());

  Future<void> loadHistory() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final data = await ApiService.getDeteksis();

      emit(state.copyWith(isLoading: false, historyData: data));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void selectItem(Map<String, dynamic>? item) {
    emit(state.copyWith(selectedData: item));
  }

  Future<void> deleteItem(int id) async {
    try {
      await ApiService.deleteDeteksi(id);

      final updated = state.historyData
          .where((e) => _toInt(e['id']) != id)
          .toList();

      Map<String, dynamic>? selected = state.selectedData;
      if (selected != null && _toInt(selected['id']) == id) {
        selected = null;
      }

      emit(state.copyWith(historyData: updated, selectedData: selected));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
