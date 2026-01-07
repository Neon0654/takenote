import '../../../data/viewmodel/note_view_model.dart';
import '../../entities/tag_entity.dart';
import '../../entities/note_entity.dart';
import '../../repositories/note_repository.dart';
import '../../repositories/tag_repository.dart';
import '../../repositories/attachment_repository.dart';
import '../../repositories/reminder_repository.dart';

/// Result returned by [LoadNotesUseCase]
class LoadNotesResult {
  final List<NoteViewModel> notes;
  final List<TagEntity> tags;

  LoadNotesResult({
    required this.notes,
    required this.tags,
  });
}

/// Use case that encapsulates the logic of loading notes and building view models.
/// Moved from NoteCubit to keep cubit thin.
/// ❗ No UI / Flutter / Cubit concepts here.
class LoadNotesUseCase {
  final NoteRepository noteRepo;
  final TagRepository tagRepo;
  final AttachmentRepository attachmentRepo;
  final ReminderRepository reminderRepo;

  LoadNotesUseCase(
    this.noteRepo,
    this.tagRepo,
    this.attachmentRepo,
    this.reminderRepo,
  );

  Future<LoadNotesResult> call({
    int? folderId,
    int? selectedTagId,
    bool isTrash = false,
    bool isUnassigned = false,
  }) async {
    // Load all tags once (same behavior as old cubit)
    final tags = await tagRepo.getAllTags();

    List<NoteEntity> notes;

    if (isTrash) {
      notes = await noteRepo.getDeletedNotes();
    } else if (isUnassigned) {
      notes = await noteRepo.getNotesWithoutFolder();
    } else if (folderId != null) {
      notes = await noteRepo.getNotes(folderId: folderId);
    } else if (selectedTagId != null) {
      notes = await tagRepo.getNotesByTag(selectedTagId);
    } else {
      notes = await noteRepo.getNotes();
    }

    final viewModels = <NoteViewModel>[];

    for (final note in notes) {
      if (note.id == null) continue;

      final noteTags = await tagRepo.getTagsOfNote(note.id!);
      final attachments = await attachmentRepo.getByNote(note.id!);
      final reminders = await reminderRepo.getByNote(note.id!);

      viewModels.add(
        NoteViewModel(
          note: note.copyWith(tags: noteTags),
          attachmentCount: attachments.length,
          attachments: attachments,
          reminders: reminders,
        ),
      );
    }

    return LoadNotesResult(
      notes: viewModels,
      tags: tags,
    );
  }
}
