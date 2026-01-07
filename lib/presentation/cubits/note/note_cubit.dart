import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../domain/repositories/tag_repository.dart';
import '../../../data/viewmodel/note_view_model.dart';
import '../../../domain/repositories/attachment_repository.dart';
import '../../../domain/repositories/reminder_repository.dart';
import '../../../domain/entities/attachment_entity.dart';

// UseCases
import '../../../domain/usecases/note/load_notes_usecase.dart';
import '../../../domain/usecases/note/add_note_usecase.dart';
import '../../../domain/usecases/note/update_note_usecase.dart';
import '../../../domain/usecases/note/add_reminder_usecase.dart';
import '../../../domain/usecases/reminder/mark_reminder_done_usecase.dart';
import '../../../domain/usecases/reminder/delete_reminder_usecase.dart';
import '../../../domain/usecases/note/delete_notes_usecase.dart';
import '../../../domain/usecases/note/restore_notes_usecase.dart';
import '../../../domain/usecases/note/delete_forever_usecase.dart';
import '../../../domain/usecases/note/move_notes_to_folder_usecase.dart';

import 'note_state.dart';

enum NoteSortField { title, createdAt, updatedAt }

enum SortOrder { asc, desc }

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepo;
  final TagRepository tagRepo;
  final AttachmentRepository attachmentRepo;
  final ReminderRepository reminderRepo;

  // Use cases (business logic moved out of cubit)
  final LoadNotesUseCase loadNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final AddReminderUseCase addReminderUseCase;
  final MarkReminderDoneUseCase markReminderDoneUseCase;
  final DeleteReminderUseCase deleteReminderUseCase;
  final DeleteNotesUseCase deleteNotesUseCase;
  final RestoreNotesUseCase restoreNotesUseCase;
  final DeleteForeverUseCase deleteForeverUseCase;
  final MoveNotesToFolderUseCase moveNotesToFolderUseCase;

  int? _folderId;
  int? _selectedTagId;
  NoteViewMode _mode = NoteViewMode.all;

  // 🎛️ sorting state owned by cubit
  NoteSortField _sortField = NoteSortField.createdAt;
  SortOrder _sortOrder = SortOrder.desc;

  List<TagEntity> _cachedTags = [];

  NoteCubit(
    this.noteRepo,
    this.tagRepo,
    this.attachmentRepo,
    this.reminderRepo, {
    LoadNotesUseCase? loadNotesUseCase,
    AddNoteUseCase? addNoteUseCase,
    UpdateNoteUseCase? updateNoteUseCase,
    AddReminderUseCase? addReminderUseCase,
    MarkReminderDoneUseCase? markReminderDoneUseCase,
    DeleteReminderUseCase? deleteReminderUseCase,
    DeleteNotesUseCase? deleteNotesUseCase,
    RestoreNotesUseCase? restoreNotesUseCase,
    DeleteForeverUseCase? deleteForeverUseCase,
    MoveNotesToFolderUseCase? moveNotesToFolderUseCase,
  }) : loadNotesUseCase =
           loadNotesUseCase ??
           LoadNotesUseCase(noteRepo, tagRepo, attachmentRepo, reminderRepo),
       addNoteUseCase = addNoteUseCase ?? AddNoteUseCase(noteRepo),
       updateNoteUseCase = updateNoteUseCase ?? UpdateNoteUseCase(noteRepo),
       addReminderUseCase =
           addReminderUseCase ?? AddReminderUseCase(reminderRepo),
       markReminderDoneUseCase = markReminderDoneUseCase ?? MarkReminderDoneUseCase(reminderRepo),
       deleteReminderUseCase = deleteReminderUseCase ?? DeleteReminderUseCase(reminderRepo),
       deleteNotesUseCase = deleteNotesUseCase ?? DeleteNotesUseCase(noteRepo),
       restoreNotesUseCase =
           restoreNotesUseCase ?? RestoreNotesUseCase(noteRepo),
       deleteForeverUseCase =
           deleteForeverUseCase ?? DeleteForeverUseCase(noteRepo),
       moveNotesToFolderUseCase =
           moveNotesToFolderUseCase ?? MoveNotesToFolderUseCase(noteRepo),
       super(NoteInitial());

  // ================= LOAD =================
  Future<void> loadNotes() async {
    try {
      emit(NoteLoading());

      // Delegate fetching and VM building to use case
      final result = await loadNotesUseCase.call(
        folderId: _folderId,
        selectedTagId: _selectedTagId,
        isTrash: _mode == NoteViewMode.trash,
        isUnassigned: _mode == NoteViewMode.unassigned,
      );

      _cachedTags = result.tags;
      final noteViewModels = result.notes;

      // Apply sorting after fetching and building view models (presentation concern)
      _applySort(noteViewModels);

      emit(
        NoteLoaded(
          notes: noteViewModels,
          tags: _cachedTags,
          selectedTagId: _selectedTagId,
          folderId: _folderId,
        ),
      );
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  // ================= FILTER =================
  void selectTag(int? tagId) {
    _mode = NoteViewMode.all;
    _selectedTagId = tagId;
    _folderId = null;
    loadNotes();
  }

  void showAll() {
    _mode = NoteViewMode.all;
    _folderId = null;
    _selectedTagId = null;
    loadNotes();
  }

  void showUnassigned() {
    _mode = NoteViewMode.unassigned;
    _folderId = null;
    _selectedTagId = null;
    loadNotes();
  }

  void showFolder(int? folderId) {
    _mode = NoteViewMode.folder;
    _folderId = folderId;
    _selectedTagId = null;
    loadNotes();
  }

  /// Show deleted notes (trash)
  void showTrash() {
    _mode = NoteViewMode.trash;
    _folderId = null;
    _selectedTagId = null;
    loadNotes();
  }

  // ================= CRUD =================
  Future<void> addNote(String title, String content, {int? folderId}) async {
    await addNoteUseCase.call(
      title: title,
      content: content,
      folderId: folderId,
    );

    if (folderId == null) {
      _folderId = null;
      _selectedTagId = null;
    }

    loadNotes();
  }

  Future<void> updateNote(NoteEntity note) async {
    await updateNoteUseCase.call(note);
    loadNotes();
  }

  Future<void> togglePin(NoteEntity note) async {
    await noteRepo.togglePin(note);
    loadNotes();
  }

  Future<void> deleteNotes(Set<int> noteIds) async {
    await deleteNotesUseCase.call(noteIds);
    loadNotes();
  }

  /// Restore notes from trash (soft restore)
  Future<void> restoreNotes(Set<int> noteIds) async {
    await restoreNotesUseCase.call(noteIds);
    loadNotes();
  }

  /// Permanently delete notes
  Future<void> deleteForever(Set<int> noteIds) async {
    await deleteForeverUseCase.call(noteIds);
    loadNotes();
  }

  Future<void> moveNotesToFolder({
    required Set<int> noteIds,
    int? folderId,
  }) async {
    await moveNotesToFolderUseCase.call(noteIds: noteIds, folderId: folderId);
    loadNotes();
  }

  // ================= SORT =================
  void setSort(NoteSortField field, SortOrder order) {
    _sortField = field;
    _sortOrder = order;
    loadNotes();
  }

  void _applySort(List<NoteViewModel> list) {
    list.sort((a, b) {
      // keep pinned notes on top
      if (a.note.isPinned != b.note.isPinned) {
        return b.note.isPinned ? 1 : -1;
      }

      int cmp = 0;

      switch (_sortField) {
        case NoteSortField.title:
          cmp = a.note.title.toLowerCase().compareTo(
            b.note.title.toLowerCase(),
          );
          break;
        case NoteSortField.createdAt:
          cmp = a.note.createdAt.compareTo(b.note.createdAt);
          break;
        case NoteSortField.updatedAt:
          cmp = a.note.updatedAt.compareTo(b.note.updatedAt);
          break;
      }

      return _sortOrder == SortOrder.asc ? cmp : -cmp;
    });
  }

  // ================= REMINDER =================
  Future<void> addReminderToNote({
    required int noteId,
    required DateTime remindAt,
  }) async {
    await addReminderUseCase.call(noteId: noteId, remindAt: remindAt);

    // refresh UI
    await loadNotes();
  }

  Future<void> markReminderDone(int reminderId) async {
    await markReminderDoneUseCase.call(reminderId);
    await loadNotes(); // 🔥 refresh lại meta
  }

  Future<void> deleteReminder(int reminderId) async {
    await deleteReminderUseCase.call(reminderId);
    await loadNotes();
  }

  // ================= ATTACHMENT =================
  Future<void> addAttachmentToNote({
    required int noteId,
    required String filePath,
    required String fileName,
  }) async {
    final attachment = AttachmentEntity(
      noteId: noteId,
      fileName: fileName,
      filePath: filePath,
    );

    await attachmentRepo.add(attachment);

    loadNotes();
  }

  Future<void> deleteAttachment(int attachmentId) async {
    await attachmentRepo.delete(attachmentId);
    loadNotes();
  }
}

enum NoteViewMode {
  all,
  folder,
  unassigned, // 👈 chưa có folder
  trash, // 👈 show deleted notes (thùng rác)
}
