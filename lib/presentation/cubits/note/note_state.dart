import 'package:equatable/equatable.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../data/viewmodel/note_view_model.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteViewModel> notes;
  final List<TagEntity> tags;
  final int? selectedTagId;
  final int? folderId;

  NoteLoaded({
    required this.notes,
    this.tags = const [],
    this.selectedTagId,
    this.folderId,
  });

  @override
  List<Object?> get props => [notes, tags, selectedTagId, folderId];
}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);

  @override
  List<Object?> get props => [message];
}