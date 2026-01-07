import '../../repositories/tag_repository.dart';


class RemoveTagFromNoteUseCase {
  final TagRepository repo;

  RemoveTagFromNoteUseCase(this.repo);

  Future<void> call({required int noteId, required int tagId}) async {
    await repo.removeTagFromNote(noteId, tagId);
  }
}
