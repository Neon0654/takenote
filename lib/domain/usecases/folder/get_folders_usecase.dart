import '../../entities/folder_entity.dart';
import '../../repositories/folder_repository.dart';

/// UseCase to get folders. Keeps repository access out of the cubit.
class GetFoldersUseCase {
  final FolderRepository repo;

  GetFoldersUseCase(this.repo);

  Future<List<FolderEntity>> call() async {
    return await repo.getFolders();
  }
}
