import '../../entities/note_entity.dart';
import '../../repositories/note_repository.dart';

/// Creates a note entity and delegates to repository. Moved from cubit.
class AddNoteUseCase {
  final NoteRepository noteRepo;

  AddNoteUseCase(this.noteRepo);

  Future<void> call({required String title, required String content, int? folderId}) async {
    await noteRepo.addNote(
      NoteEntity(
        title: title,
        content: content,
        createdAt: DateTime.now(),
        isDeleted: false,
        isPinned: false,
      ),
      folderId: folderId,
    );
  }
}
