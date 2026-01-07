import '../entities/tag_entity.dart';
import '../entities/note_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> getAllTags();
  Future<List<TagEntity>> getTagsOfNote(int noteId);

  Future<List<NoteEntity>> getNotesByTag(int tagId);

  Future<int> createTag(String name);
  Future<void> renameTag(int tagId, String newName);
  Future<void> addTagToNote(int noteId, int tagId);
  Future<void> removeTagFromNote(int noteId, int tagId);
  Future<void> deleteTag(int tagId);
}
