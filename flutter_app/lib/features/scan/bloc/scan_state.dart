import 'dart:io';

const Object _unset = Object();

class ScanState {
  final int? selectedLahanId;
  final File? image;
  final bool isLoadingLahan;

  const ScanState({
    this.selectedLahanId,
    this.image,
    this.isLoadingLahan = true,
  });

  ScanState copyWith({
    Object? selectedLahanId = _unset,
    Object? image = _unset,
    bool? isLoadingLahan,
  }) {
    return ScanState(
      selectedLahanId: selectedLahanId == _unset
          ? this.selectedLahanId
          : selectedLahanId as int?,
      image: image == _unset ? this.image : image as File?,
      isLoadingLahan: isLoadingLahan ?? this.isLoadingLahan,
    );
  }
}
