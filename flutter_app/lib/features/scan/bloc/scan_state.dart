import 'dart:io';

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
    int? selectedLahanId,
    File? image,
    bool? isLoadingLahan,
  }) {
    return ScanState(
      selectedLahanId: selectedLahanId ?? this.selectedLahanId,
      image: image ?? this.image,
      isLoadingLahan: isLoadingLahan ?? this.isLoadingLahan,
    );
  }
}
