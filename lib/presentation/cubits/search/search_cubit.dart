import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/note_repository.dart';
import 'search_state.dart';
import 'search_time_filter.dart';

class SearchCubit extends Cubit<SearchState> {
  final NoteRepository repo;

  SearchTimeFilter _filter = SearchTimeFilter.all;
  String _lastKeyword = '';

  SearchCubit(this.repo) : super(SearchIdle(SearchTimeFilter.all));

  void setFilter(SearchTimeFilter filter) {
    // 🔁 Toggle: bấm lại chip đang chọn → về ALL
    if (_filter == filter) {
      _filter = SearchTimeFilter.all;
    } else {
      _filter = filter;
    }

    // 🔍 Luôn search lại (kể cả keyword rỗng)
    search(_lastKeyword);
  }

  Future<void> search(String keyword) async {
    _lastKeyword = keyword;
    emit(SearchLoading(_filter));

    try {
      final allNotes = keyword.trim().isEmpty
          ? await repo.getNotes()
          : await repo.searchNotes(keyword: keyword);

      final fromDate = _calculateFromDate(_filter);

      final results = allNotes.where((note) {
        return note.createdAt.isAfter(fromDate);
      }).toList();

      emit(SearchLoaded(results, _filter));
    } catch (e) {
      emit(SearchError(e.toString(), _filter));
    }
  }

  DateTime _calculateFromDate(SearchTimeFilter filter) {
    final now = DateTime.now();

    switch (filter) {
      case SearchTimeFilter.yesterday:
        return now.subtract(const Duration(days: 1));
      case SearchTimeFilter.last7Days:
        return now.subtract(const Duration(days: 7));
      case SearchTimeFilter.last30Days:
        return now.subtract(const Duration(days: 30));
      case SearchTimeFilter.all:
        return DateTime(2000);
    }
  }
}
