import 'package:equatable/equatable.dart';
import '../../../domain/entities/note_entity.dart';

abstract class TrashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrashLoading extends TrashState {}

class TrashLoaded extends TrashState {
  final List<NoteEntity> notes;
  TrashLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}
