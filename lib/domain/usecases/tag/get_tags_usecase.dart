import '../../entities/tag_entity.dart';
import '../../repositories/tag_repository.dart';

/// UseCase to get all tags.
class GetTagsUseCase {
  final TagRepository repo;

  GetTagsUseCase(this.repo);

  Future<List<TagEntity>> call() async {
    return await repo.getAllTags();
  }
}
