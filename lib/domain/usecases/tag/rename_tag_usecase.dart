import '../../repositories/tag_repository.dart';

/// Renames a tag if new name is non-empty.
class RenameTagUseCase {
  final TagRepository repo;

  RenameTagUseCase(this.repo);

  Future<void> call({required int tagId, required String newName}) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    await repo.renameTag(tagId, trimmed);
  }
}
