import '../../repositories/note_repository.dart';

/// Permanently deletes notes. Moved from cubit.
class DeleteForeverUseCase {
  final NoteRepository noteRepo;

  DeleteForeverUseCase(this.noteRepo);

  Future<void> call(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.deleteNotePermanently(id);
    }
  }
}
