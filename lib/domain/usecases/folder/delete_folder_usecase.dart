import '../../repositories/folder_repository.dart';

/// Deletes a folder via repository.
class DeleteFolderUseCase {
  final FolderRepository repo;

  DeleteFolderUseCase(this.repo);

  Future<void> call(int id) async {
    await repo.deleteFolder(id);
  }
}
