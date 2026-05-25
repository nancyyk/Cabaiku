import 'package:equatable/equatable.dart';
import '../lahan_model.dart';

class LahanState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final List<Lahan> allLahan;
  final List<Lahan> filteredLahan;

  final Lahan? selectedLahan;

  final String searchQuery;
  final String selectedStatus;

  const LahanState({
    required this.isLoading,
    required this.errorMessage,
    required this.allLahan,
    required this.filteredLahan,
    required this.selectedLahan,
    required this.searchQuery,
    required this.selectedStatus,
  });

  factory LahanState.initial() {
    return const LahanState(
      isLoading: false,
      errorMessage: null,
      allLahan: [],
      filteredLahan: [],
      selectedLahan: null,
      searchQuery: "",
      selectedStatus: "Semua",
    );
  }

  LahanState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Lahan>? allLahan,
    List<Lahan>? filteredLahan,
    Lahan? selectedLahan,
    String? searchQuery,
    String? selectedStatus,
  }) {
    return LahanState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      allLahan: allLahan ?? this.allLahan,
      filteredLahan: filteredLahan ?? this.filteredLahan,
      selectedLahan: selectedLahan,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        allLahan,
        filteredLahan,
        selectedLahan,
        searchQuery,
        selectedStatus,
      ];
}