import '../../repositories/tag_repository.dart';


class CreateTagUseCase {
  final TagRepository repo;

  CreateTagUseCase(this.repo);

  Future<void> call(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    await repo.createTag(trimmed);
  }
}
