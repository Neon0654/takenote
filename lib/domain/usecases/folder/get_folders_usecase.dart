import '../../entities/folder_entity.dart';
import '../../repositories/folder_repository.dart';

class GetFoldersUseCase {
  final FolderRepository repo;

  GetFoldersUseCase(this.repo);

  Future<List<FolderEntity>> call() async {
    return await repo.getFolders();
  }
}
