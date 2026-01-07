import '../../repositories/tag_repository.dart';

/// Associates a tag with a note via repository.
class AddTagToNoteUseCase {
  final TagRepository repo;

  AddTagToNoteUseCase(this.repo);

  Future<void> call({required int noteId, required int tagId}) async {
    await repo.addTagToNote(noteId, tagId);
  }
}
