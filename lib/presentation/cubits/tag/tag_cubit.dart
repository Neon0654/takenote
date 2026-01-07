import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/tag_repository.dart';

import 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final TagRepository repo;

  TagCubit(this.repo) : super(TagInitial());

  // ===== LOAD =====
  Future<void> loadTags() async {
    try {
      emit(TagLoading());
      final tags = await repo.getAllTags();
      emit(TagLoaded(tags));
    } catch (e) {
      emit(TagError(e.toString()));
    }
  }

  // ===== CRUD =====
  Future<void> createTag(String name) async {
    if (name.trim().isEmpty) return;

    await repo.createTag(name);
    await loadTags();
  }

  Future<void> renameTag(int tagId, String newName) async {
    if (newName.trim().isEmpty) return;

    await repo.renameTag(tagId, newName.trim());
    await loadTags();
  }

  Future<void> deleteTag(int tagId) async {
    // nếu có deleteTag trong repo
    await repo.deleteTag(tagId);

    await loadTags();
  }

  // ===== NOTE ↔ TAG =====
  Future<void> addTagToNote({required int noteId, required int tagId}) async {
    await repo.addTagToNote(noteId, tagId);
  }

  Future<void> removeTagFromNote({
    required int noteId,
    required int tagId,
  }) async {
    await repo.removeTagFromNote(noteId, tagId);
  }
}
