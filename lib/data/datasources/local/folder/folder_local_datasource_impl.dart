import '../../../database/notes_database.dart';
import '../../../models/folder_model.dart';
import '../../../models/note_model.dart';
import 'folder_local_datasource.dart';

class FolderLocalDataSourceImpl implements FolderLocalDataSource {
  final NotesDatabase db;

  FolderLocalDataSourceImpl(this.db);

  @override
  Future<List<FolderModel>> fetchFolders() {
    return db.fetchFolders();
  }

  @override
  Future<int> createFolder(FolderModel folder) {
    return db.createFolder(folder);
  }

  @override
  Future<void> deleteFolder(int id) {
    return db.deleteFolder(id);
  }

  @override
  Future<List<NoteModel>> fetchNotesByFolder(int folderId) {
    return db.fetchNotesByFolder(folderId);
  }

  @override
  Future<void> linkNoteToFolder(int noteId, int folderId) {
    return db.linkNoteToFolder(noteId, folderId);
  }

  @override
  Future<Map<int, int>> countNotesByFolder() {
    return db.countNotesByFolder();
  }

  @override
  Future<void> moveNoteToFolder({required int noteId, int? folderId}) {
    return db.moveNoteToFolder(noteId: noteId, folderId: folderId);
  }

  @override
  Future<void> renameFolder(int folderId, String name) {
    return db.renameFolder(folderId, name);
  }
}
