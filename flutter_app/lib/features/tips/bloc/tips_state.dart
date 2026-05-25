import 'package:equatable/equatable.dart';

class TipsState extends Equatable {
  final bool isShowingDetail;
  final Map<String, String>? selectedArticle;
  final String selectedCategory;
  final String searchQuery;

  const TipsState({
    required this.isShowingDetail,
    required this.selectedArticle,
    required this.selectedCategory,
    required this.searchQuery,
  });

  factory TipsState.initial() {
    return const TipsState(
      isShowingDetail: false,
      selectedArticle: null,
      selectedCategory: "Semua",
      searchQuery: "",
    );
  }

  TipsState copyWith({
    bool? isShowingDetail,
    Map<String, String>? selectedArticle,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return TipsState(
      isShowingDetail:
          isShowingDetail ?? this.isShowingDetail,
      selectedArticle:
          selectedArticle ?? this.selectedArticle,
      selectedCategory:
          selectedCategory ?? this.selectedCategory,
      searchQuery:
          searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        isShowingDetail,
        selectedArticle,
        selectedCategory,
        searchQuery,
      ];
}