import '../data/database/notes_database.dart';
import '../data/models/folder.dart';

class FolderController {
  const FolderController();

  Future<void> createFolder(String name, int color) async {
    if (name.trim().isEmpty) return;

    await NotesDatabase.instance.createFolder(
      Folder(
        name: name.trim(),
        color: color,
        createdAt: DateTime.now(),
      ),
    );
  }
}
