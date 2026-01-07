import '../entities/folder_entity.dart';

abstract class FolderRepository {
  Future<List<FolderEntity>> getFolders();
  Future<int> createFolder(FolderEntity folder);
  Future<void> deleteFolder(int folderId);
  Future<Map<int, int>> getNoteCountByFolder();
  Future<void> renameFolder(int folderId, String name);
}
