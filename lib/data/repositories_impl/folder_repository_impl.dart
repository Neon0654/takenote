import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/local/folder/folder_local_datasource.dart';
import '../models/folder_model.dart';

class FolderRepositoryImpl implements FolderRepository {
  final FolderLocalDataSource local;

  FolderRepositoryImpl(this.local);

  @override
  Future<List<FolderEntity>> getFolders() async {
    final models = await local.fetchFolders();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> createFolder(FolderEntity folder) {
    return local.createFolder(
      FolderModel(
        name: folder.name,
        color: folder.colorValue,
        createdAt: folder.createdAt,
      ),
    );
  }

  @override
  Future<void> deleteFolder(int folderId) {
    return local.deleteFolder(folderId);
  }

  @override
  Future<Map<int, int>> getNoteCountByFolder() {
    return local.countNotesByFolder();
  }

  @override
  Future<void> renameFolder(int folderId, String name) {
    return local.renameFolder(folderId, name);
  }
}
