import 'package:flutter_bloc/flutter_bloc.dart';
import 'tips_state.dart';

class TipsBloc extends Cubit<TipsState> {
  TipsBloc() : super(TipsState.initial());

  void changeCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
      ),
    );
  }

  void searchArticle(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
      ),
    );
  }

  void openDetail(Map<String, String> article) {
    emit(
      state.copyWith(
        isShowingDetail: true,
        selectedArticle: article,
      ),
    );
  }

  void closeDetail() {
    emit(
      state.copyWith(
        isShowingDetail: false,
        selectedArticle: null,
      ),
    );
  }
}