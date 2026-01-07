import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/note_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final NoteRepository repo;

  SearchCubit(this.repo) : super(SearchIdle());

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      emit(SearchIdle());
      return;
    }

    emit(SearchLoading());

    try {
      final fromDate = DateTime(2000);
      final results = await repo.searchNotes(
        keyword: keyword,
        fromDate: fromDate,
      );

      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
