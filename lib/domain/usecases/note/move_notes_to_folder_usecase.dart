import '../../repositories/note_repository.dart';


class MoveNotesToFolderUseCase {
  final NoteRepository noteRepo;

  MoveNotesToFolderUseCase(this.noteRepo);

  Future<void> call({required Set<int> noteIds, int? folderId}) async {
    for (final id in noteIds) {
      await noteRepo.moveNoteToFolder(noteId: id, folderId: folderId);
    }
  }
}
