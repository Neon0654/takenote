import '../../repositories/tag_repository.dart';


class DeleteTagUseCase {
  final TagRepository repo;

  DeleteTagUseCase(this.repo);

  Future<void> call(int tagId) async {
    await repo.deleteTag(tagId);
  }
}
