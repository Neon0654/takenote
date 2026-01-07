import '../../entities/note_entity.dart';
import '../../repositories/note_repository.dart';

/// Updates a note, ensuring updatedAt is set to now. Moved from cubit.
class UpdateNoteUseCase {
  final NoteRepository noteRepo;

  UpdateNoteUseCase(this.noteRepo);

  Future<void> call(NoteEntity note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    await noteRepo.updateNote(updated);
  }
}
