import '../../../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<int> createNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<NoteModel?> getNoteById(int id);

  Future<List<NoteModel>> fetchNotes();
  Future<List<NoteModel>> fetchTrashNotes();

  Future<void> moveNoteToTrash(int id);
  Future<void> restoreNote(int id);
  Future<void> deleteNotePermanently(int id);

  Future<List<NoteModel>> searchNotesWithRange(
    String keyword,
    DateTime? fromDate,
  );

  Future<List<NoteModel>> getNotesWithoutFolder();
  Future<void> moveNoteToFolder({required int noteId, int? folderId});
}
