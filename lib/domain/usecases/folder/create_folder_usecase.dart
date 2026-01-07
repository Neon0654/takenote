import '../../entities/folder_entity.dart';
import '../../repositories/folder_repository.dart';

class CreateFolderUseCase {
  final FolderRepository repo;

  CreateFolderUseCase(this.repo);

  Future<void> call({required String name, required int color}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return; 

    await repo.createFolder(
      FolderEntity(
        name: trimmed,
        colorValue: color,
        createdAt: DateTime.now(),
      ),
    );
  }
}
