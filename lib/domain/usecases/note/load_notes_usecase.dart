import '../../../data/viewmodel/note_view_model.dart';
import '../../entities/tag_entity.dart';
import '../../entities/note_entity.dart';
import '../../repositories/note_repository.dart';
import '../../repositories/tag_repository.dart';
import '../../repositories/attachment_repository.dart';
import '../../repositories/reminder_repository.dart';

class LoadNotesResult {
  final List<NoteViewModel> notes;
  final List<TagEntity> tags;

  LoadNotesResult({required this.notes, required this.tags});
}

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
    final tags = await tagRepo.getAllTags();

    List<NoteEntity> notes;

    if (isTrash) {
      notes = await noteRepo.getDeletedNotes();
    } else if (isUnassigned) {
      notes = await noteRepo.getNotesWithoutFolder();
    } else if (folderId != null) {
      notes = await noteRepo.getNotes(folderId: folderId);
    } else {
      notes = await noteRepo.getNotes();
    }

    if (selectedTagId != null) {
      final notesByTag = await tagRepo.getNotesByTag(selectedTagId);
      final noteIdsByTag = notesByTag.map((e) => e.id).toSet();

      notes = notes.where((n) => noteIdsByTag.contains(n.id)).toList();
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

    return LoadNotesResult(notes: viewModels, tags: tags);
  }
}
