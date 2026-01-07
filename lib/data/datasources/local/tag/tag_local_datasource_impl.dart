import '../../../database/notes_database.dart';
import '../../../models/tag_model.dart';
import '../../../models/note_model.dart';
import 'tag_local_datasource.dart';

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final NotesDatabase db;

  TagLocalDataSourceImpl(this.db);

  @override
  Future<List<TagModel>> fetchTags() {
    return db.fetchTags();
  }

  @override
  Future<List<TagModel>> getTagsOfNote(int noteId) {
    return db.getTagsOfNote(noteId);
  }

  @override
  Future<List<NoteModel>> getNotesByTag(int tagId) {
    return db.getNotesByTag(tagId);
  }

  @override
  Future<int> createTag(String name) {
    return db.createTag(name);
  }

  @override
  Future<void> renameTag(int tagId, String newName) {
    return db.renameTag(tagId, newName);
  }

  @override
  Future<void> addTagToNote(int noteId, int tagId) {
    return db.addTagToNote(noteId, tagId);
  }

  @override
  Future<void> removeTagFromNote(int noteId, int tagId) {
    return db.removeTagFromNote(noteId, tagId);
  }

  @override
  Future<void> deleteTag(int tagId, int unused) {
    return db.deleteTag(tagId);
  }
}
