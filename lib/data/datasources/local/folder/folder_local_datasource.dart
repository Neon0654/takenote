import '../../../models/folder_model.dart';
import '../../../models/note_model.dart';

abstract class FolderLocalDataSource {
  Future<List<FolderModel>> fetchFolders();
  Future<int> createFolder(FolderModel folder);
  Future<void> deleteFolder(int id);

  Future<List<NoteModel>> fetchNotesByFolder(int folderId);
  Future<void> linkNoteToFolder(int noteId, int folderId);

  Future<Map<int, int>> countNotesByFolder();

  Future<void> moveNoteToFolder({required int noteId, int? folderId});

  Future<void> renameFolder(int folderId, String name);
}
