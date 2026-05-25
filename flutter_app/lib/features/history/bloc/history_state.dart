import 'package:equatable/equatable.dart';

class HistoryState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final List<Map<String, dynamic>> historyData;
  final Map<String, dynamic>? selectedData;

  const HistoryState({
    required this.isLoading,
    required this.errorMessage,
    required this.historyData,
    required this.selectedData,
  });

  factory HistoryState.initial() {
    return const HistoryState(
      isLoading: true,
      errorMessage: null,
      historyData: [],
      selectedData: null,
    );
  }

  HistoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Map<String, dynamic>>? historyData,
    Map<String, dynamic>? selectedData,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      historyData: historyData ?? this.historyData,
      selectedData: selectedData,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        historyData,
        selectedData,
      ];
}