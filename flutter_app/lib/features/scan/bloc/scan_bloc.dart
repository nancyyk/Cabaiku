import 'dart:io';

import 'scan_state.dart';

class ScanBloc {
  ScanState state;

  ScanBloc({ScanState? initialState})
    : state = initialState ?? const ScanState();

  void setSelectedLahanId(int? id) {
    state = state.copyWith(selectedLahanId: id);
  }

  void setImage(File? image) {
    state = state.copyWith(image: image);
  }

  void setLoadingLahan(bool isLoading) {
    state = state.copyWith(isLoadingLahan: isLoading);
  }
}
