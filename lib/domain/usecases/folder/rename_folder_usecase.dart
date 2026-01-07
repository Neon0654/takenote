import '../../repositories/folder_repository.dart';

class RenameFolderUseCase {
  final FolderRepository repo;

  RenameFolderUseCase(this.repo);

  Future<void> call({required int id, required String newName}) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    await repo.renameFolder(id, trimmed);
  }
}
