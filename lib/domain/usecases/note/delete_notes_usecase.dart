import '../../repositories/note_repository.dart';

/// Moves notes to trash (soft delete) for given ids. Moved from cubit.
class DeleteNotesUseCase {
  final NoteRepository noteRepo;

  DeleteNotesUseCase(this.noteRepo);

  Future<void> call(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.moveToTrash(id);
    }
  }
}
