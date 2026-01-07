import '../../repositories/note_repository.dart';

/// Restores notes from trash. Moved from cubit.
class RestoreNotesUseCase {
  final NoteRepository noteRepo;

  RestoreNotesUseCase(this.noteRepo);

  Future<void> call(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.restoreNote(id);
    }
  }
}
