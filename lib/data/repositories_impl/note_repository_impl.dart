import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

import '../datasources/local/note/note_local_datasource.dart';
import '../datasources/local/tag/tag_local_datasource.dart';
import '../datasources/local/folder/folder_local_datasource.dart';

import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource noteLocal;
  final TagLocalDataSource tagLocal;
  final FolderLocalDataSource folderLocal;

  NoteRepositoryImpl({
    required this.noteLocal,
    required this.tagLocal,
    required this.folderLocal,
  });

  

  @override
  Future<List<NoteEntity>> getNotes({int? folderId, int? tagId}) async {
    List<NoteModel> models;

    if (folderId != null) {
      models = await folderLocal.fetchNotesByFolder(folderId);
    } else if (tagId != null) {
      models = await tagLocal.getNotesByTag(tagId);
    } else {
      models = await noteLocal.fetchNotes();
    }

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> addNote(NoteEntity note, {int? folderId}) async {
    final id = await noteLocal.createNote(
      NoteModel(
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        isPinned: note.isPinned,
        isDeleted: note.isDeleted,
      ),
    );

    if (folderId != null) {
      await folderLocal.linkNoteToFolder(id, folderId);
    }

    return id;
  }

  @override
  Future<void> updateNote(NoteEntity note) {
    return noteLocal.updateNote(
      NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        isPinned: note.isPinned,
        isDeleted: note.isDeleted,
      ),
    );
  }

  @override
  Future<void> togglePin(NoteEntity note) {
    return updateNote(
      NoteEntity(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: DateTime.now(), 
        isPinned: !note.isPinned,
        isDeleted: note.isDeleted,
      ),
    );
  }

  @override
  Future<void> moveToTrash(int noteId) {
    return noteLocal.moveNoteToTrash(noteId);
  }

  @override
  Future<List<NoteEntity>> getDeletedNotes() async {
    final models = await noteLocal.fetchTrashNotes();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> restoreNote(int noteId) {
    return noteLocal.restoreNote(noteId);
  }

  @override
  Future<void> deleteNotePermanently(int noteId) {
    return noteLocal.deleteNotePermanently(noteId);
  }

  @override
  Future<List<NoteEntity>> getNotesWithoutFolder() async {
    final models = await noteLocal.getNotesWithoutFolder();
    return models.map((e) => e.toEntity()).toList();
  }

    @override
  Future<void> moveNoteToFolder({required int noteId, int? folderId}) {
    return noteLocal.moveNoteToFolder(noteId: noteId, folderId: folderId);
  }

  @override
  Future<List<NoteEntity>> searchNotes({
    required String keyword,
    DateTime? fromDate,
  }) async {
    final models = await noteLocal.searchNotesWithRange(keyword, fromDate);

    return models.map((e) => e.toEntity()).toList();
  }
}
