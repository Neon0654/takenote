import '../../repositories/note_repository.dart';


class DeleteNotesUseCase {
  final NoteRepository noteRepo;

  DeleteNotesUseCase(this.noteRepo);

  Future<void> call(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.moveToTrash(id);
    }
  }
}
