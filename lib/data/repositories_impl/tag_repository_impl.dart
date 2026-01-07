import '../../domain/entities/tag_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/tag_repository.dart';

import '../datasources/local/tag/tag_local_datasource.dart';
import '../models/tag_model.dart';
import '../models/note_model.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource local;

  TagRepositoryImpl(this.local);

  @override
  Future<List<TagEntity>> getAllTags() async {
    final List<TagModel> models = await local.fetchTags();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<TagEntity>> getTagsOfNote(int noteId) async {
    final models = await local.getTagsOfNote(noteId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<NoteEntity>> getNotesByTag(int tagId) async {
    final List<NoteModel> models = await local.getNotesByTag(tagId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> createTag(String name) {
    return local.createTag(name);
  }

  @override
  Future<void> renameTag(int tagId, String newName) {
    return local.renameTag(tagId, newName);
  }

  @override
  Future<void> addTagToNote(int noteId, int tagId) {
    return local.addTagToNote(noteId, tagId);
  }

  @override
  Future<void> removeTagFromNote(int noteId, int tagId) {
    return local.removeTagFromNote(noteId, tagId);
  }

  @override
  Future<void> deleteTag(int tagId) {
    return local.deleteTag(tagId, tagId);
  }
}
