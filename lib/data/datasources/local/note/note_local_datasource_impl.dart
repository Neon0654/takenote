import '../../../database/notes_database.dart';
import '../../../models/note_model.dart';
import 'note_local_datasource.dart';

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final NotesDatabase db;

  NoteLocalDataSourceImpl(this.db);

  @override
  Future<int> createNote(NoteModel note) {
    return db.createNote(note);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await db.updateNote(note);
  }

  @override
  Future<NoteModel?> getNoteById(int id) {
    return db.getNoteById(id);
  }

  @override
  Future<List<NoteModel>> fetchNotes() {
    return db.fetchNotes();
  }

  @override
  Future<List<NoteModel>> fetchTrashNotes() {
    return db.fetchTrashNotes();
  }

  @override
  Future<void> moveNoteToTrash(int id) {
    return db.moveNoteToTrash(id);
  }

  @override
  Future<void> restoreNote(int id) {
    return db.restoreNote(id);
  }

  @override
  Future<void> deleteNotePermanently(int id) {
    return db.deleteNotePermanently(id);
  }

  @override
  Future<List<NoteModel>> searchNotesWithRange(
    String keyword,
    DateTime? fromDate,
  ) {
    if (fromDate == null) {
    return db.searchNotes(keyword);
  }
    return db.searchNotesWithRange(keyword, fromDate);
  }

  @override
  Future<List<NoteModel>> getNotesWithoutFolder() async {
    final result = await db.getNotesWithoutFolder();

    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  @override
  Future<void> moveNoteToFolder({required int noteId, int? folderId}) {
    return db.moveNoteToFolder(noteId: noteId, folderId: folderId);
  }
}
