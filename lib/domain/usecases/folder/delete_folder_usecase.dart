import '../../repositories/folder_repository.dart';

class DeleteFolderUseCase {
  final FolderRepository repo;

  DeleteFolderUseCase(this.repo);

  Future<void> call(int id) async {
    await repo.deleteFolder(id);
  }
}
