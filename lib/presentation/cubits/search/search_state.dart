import 'package:equatable/equatable.dart';
import '../../../domain/entities/note_entity.dart';
import 'search_time_filter.dart';

abstract class SearchState extends Equatable {
  final SearchTimeFilter filter;
  const SearchState(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchIdle extends SearchState {
  SearchIdle(SearchTimeFilter filter) : super(filter);
}

class SearchLoading extends SearchState {
  SearchLoading(SearchTimeFilter filter) : super(filter);
}

class SearchLoaded extends SearchState {
  final List<NoteEntity> results;
  SearchLoaded(this.results, SearchTimeFilter filter) : super(filter);

  @override
  List<Object?> get props => [results, filter];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message, SearchTimeFilter filter) : super(filter);

  @override
  List<Object?> get props => [message, filter];
}
