import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/repositories/note_repository.dart';
import 'trash_state.dart';

class TrashCubit extends Cubit<TrashState> {
  final NoteRepository repo;

  TrashCubit(this.repo) : super(TrashLoading());

  Future<void> loadTrash() async {
    final notes = await repo.getNotes(); // sau này tách trash riêng
    emit(TrashLoaded(notes.where((n) => n.isDeleted).toList()));
  }

  Future<void> restore(NoteEntity note) async {
    await repo.updateNote(
      NoteEntity(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        isDeleted: false,
      ),
    );
    loadTrash();
  }
}
