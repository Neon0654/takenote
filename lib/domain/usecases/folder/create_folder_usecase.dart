import '../../entities/folder_entity.dart';
import '../../repositories/folder_repository.dart';

/// Creates a folder. Validates input and delegates to repository.
class CreateFolderUseCase {
  final FolderRepository repo;

  CreateFolderUseCase(this.repo);

  /// Creates folder only if [name] is not empty after trimming.
  Future<void> call({required String name, required int color}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return; // preserve previous behavior (no-op on empty)

    await repo.createFolder(
      FolderEntity(
        name: trimmed,
        colorValue: color,
        createdAt: DateTime.now(),
      ),
    );
  }
}
