import '../../repositories/tag_repository.dart';

/// Creates a tag if the name is not empty (preserves previous validation behavior).
class CreateTagUseCase {
  final TagRepository repo;

  CreateTagUseCase(this.repo);

  Future<void> call(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    await repo.createTag(trimmed);
  }
}
