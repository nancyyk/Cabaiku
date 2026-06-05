import 'package:equatable/equatable.dart';

import '../../disease_care/disease_care_data.dart';

class TipsState extends Equatable {
  final bool isShowingDetail;
  final DiseaseCareContent? selectedArticle;
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
    DiseaseCareContent? selectedArticle,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return TipsState(
      isShowingDetail: isShowingDetail ?? this.isShowingDetail,
      selectedArticle: selectedArticle ?? this.selectedArticle,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
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
