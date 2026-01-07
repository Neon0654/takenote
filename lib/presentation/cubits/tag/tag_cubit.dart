import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/tag_repository.dart';
import '../../../domain/entities/tag_entity.dart';


import '../../../domain/usecases/tag/get_tags_usecase.dart';
import '../../../domain/usecases/tag/create_tag_usecase.dart';
import '../../../domain/usecases/tag/rename_tag_usecase.dart';
import '../../../domain/usecases/tag/delete_tag_usecase.dart';
import '../../../domain/usecases/tag/add_tag_to_note_usecase.dart';
import '../../../domain/usecases/tag/remove_tag_from_note_usecase.dart';

import 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  final TagRepository repo;

  
  final GetTagsUseCase getTagsUseCase;
  final CreateTagUseCase createTagUseCase;
  final RenameTagUseCase renameTagUseCase;
  final DeleteTagUseCase deleteTagUseCase;
  final AddTagToNoteUseCase addTagToNoteUseCase;
  final RemoveTagFromNoteUseCase removeTagFromNoteUseCase;

  TagCubit(
    this.repo, {
    GetTagsUseCase? getTagsUseCase,
    CreateTagUseCase? createTagUseCase,
    RenameTagUseCase? renameTagUseCase,
    DeleteTagUseCase? deleteTagUseCase,
    AddTagToNoteUseCase? addTagToNoteUseCase,
    RemoveTagFromNoteUseCase? removeTagFromNoteUseCase,
  })  : getTagsUseCase = getTagsUseCase ?? GetTagsUseCase(repo),
        createTagUseCase = createTagUseCase ?? CreateTagUseCase(repo),
        renameTagUseCase = renameTagUseCase ?? RenameTagUseCase(repo),
        deleteTagUseCase = deleteTagUseCase ?? DeleteTagUseCase(repo),
        addTagToNoteUseCase = addTagToNoteUseCase ?? AddTagToNoteUseCase(repo),
        removeTagFromNoteUseCase = removeTagFromNoteUseCase ?? RemoveTagFromNoteUseCase(repo),
        super(TagInitial());

  
  Future<void> loadTags() async {
    try {
      emit(TagLoading());
      final tags = await getTagsUseCase.call();
      emit(TagLoaded(tags));
    } catch (e) {
      emit(TagError(e.toString()));
    }
  }

  
  Future<void> createTag(String name) async {
    
    if (name.trim().isEmpty) return;

    await createTagUseCase.call(name.trim());
    await loadTags();
  }

  Future<void> renameTag(int tagId, String newName) async {
    if (newName.trim().isEmpty) return;

    await renameTagUseCase.call(tagId: tagId, newName: newName.trim());
    await loadTags();
  }

  Future<void> deleteTag(int tagId) async {
    await deleteTagUseCase.call(tagId);

    await loadTags();
  }

  
  Future<void> addTagToNote({required int noteId, required int tagId}) async {
    await addTagToNoteUseCase.call(noteId: noteId, tagId: tagId);
  }

  Future<void> removeTagFromNote({
    required int noteId,
    required int tagId,
  }) async {
    await removeTagFromNoteUseCase.call(noteId: noteId, tagId: tagId);
  }

  
  Future<List<TagEntity>> getTagsOfNote(int noteId) async {
    return await repo.getTagsOfNote(noteId);
  }
}
