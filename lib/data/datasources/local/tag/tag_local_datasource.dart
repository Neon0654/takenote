import '../../../models/tag_model.dart';
import '../../../models/note_model.dart';

abstract class TagLocalDataSource {
  Future<List<TagModel>> fetchTags();
  Future<List<TagModel>> getTagsOfNote(int noteId);
  Future<List<NoteModel>> getNotesByTag(int tagId);

  Future<int> createTag(String name);
  Future<void> renameTag(int tagId, String newName);
  Future<void> addTagToNote(int noteId, int tagId);
  Future<void> removeTagFromNote(int noteId, int tagId);
  Future<void> deleteTag(int tagId, int unused);
}

