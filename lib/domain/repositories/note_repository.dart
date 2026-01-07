import '../entities/note_entity.dart';

abstract class NoteRepository {
  // ===== NOTE =====
  Future<List<NoteEntity>> getNotes({int? folderId, int? tagId});

  Future<int> addNote(NoteEntity note, {int? folderId});
  Future<void> updateNote(NoteEntity note);
  Future<void> togglePin(NoteEntity note);

  Future<void> moveToTrash(int noteId);

  // Trash related
  Future<List<NoteEntity>> getDeletedNotes();
  Future<void> restoreNote(int noteId);
  Future<void> deleteNotePermanently(int noteId);

  Future<List<NoteEntity>> getNotesWithoutFolder();

  Future<void> moveNoteToFolder({required int noteId, int? folderId});

  // ===== SEARCH =====
  Future<List<NoteEntity>> searchNotes({
    required String keyword,
    DateTime? fromDate,
  });
}
