import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../domain/repositories/tag_repository.dart';
import '../../../data/viewmodel/note_view_model.dart';
import '../../../domain/repositories/attachment_repository.dart';
import '../../../domain/repositories/reminder_repository.dart';
import '../../../domain/entities/attachment_entity.dart';
import '../../../domain/entities/reminder_entity.dart';
import '../../../services/notification_service.dart';

import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepo;
  final TagRepository tagRepo;
  final AttachmentRepository attachmentRepo;
  final ReminderRepository reminderRepo;

  int? _folderId;
  int? _selectedTagId;
  NoteViewMode _mode = NoteViewMode.all;

  List<TagEntity> _cachedTags = [];

  NoteCubit(this.noteRepo, this.tagRepo, this.attachmentRepo, this.reminderRepo)
    : super(NoteInitial());

  // ================= LOAD =================
  Future<void> loadNotes() async {
    try {
      emit(NoteLoading());

      if (_cachedTags.isEmpty) {
        _cachedTags = await tagRepo.getAllTags();
      }

      List<NoteEntity> notes;

      switch (_mode) {
        case NoteViewMode.folder:
          notes = await noteRepo.getNotes(folderId: _folderId);
          break;
        case NoteViewMode.unassigned:
          notes = await noteRepo.getNotesWithoutFolder();
          break;
        case NoteViewMode.trash:
          notes = await noteRepo.getDeletedNotes();
          break;
        case NoteViewMode.all:
          notes = _selectedTagId != null
              ? await tagRepo.getNotesByTag(_selectedTagId!)
              : await noteRepo.getNotes();
      }

      final noteViewModels = <NoteViewModel>[];

      for (final note in notes) {
        if (note.id == null) continue;

        final tags = await tagRepo.getTagsOfNote(note.id!);
        final attachments = await attachmentRepo.getByNote(note.id!);
        final reminders = await reminderRepo.getByNote(note.id!);

        noteViewModels.add(
          NoteViewModel(
            note: note.copyWith(tags: tags),
            attachmentCount: attachments.length,
            attachments: attachments,
            reminders: reminders,
          ),
        );
      }

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
    await noteRepo.addNote(
      NoteEntity(
        title: title,
        content: content,
        createdAt: DateTime.now(),
        isDeleted: false,
        isPinned: false,
      ),
      folderId: folderId,
    );

    if (folderId == null) {
      _folderId = null;
      _selectedTagId = null;
    }

    loadNotes();
  }

  Future<void> updateNote(NoteEntity note) async {
    await noteRepo.updateNote(note);
    loadNotes();
  }

  Future<void> togglePin(NoteEntity note) async {
    await noteRepo.togglePin(note);
    loadNotes();
  }

  Future<void> deleteNotes(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.moveToTrash(id);
    }
    loadNotes();
  }

  /// Restore notes from trash (soft restore)
  Future<void> restoreNotes(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.restoreNote(id);
    }
    loadNotes();
  }

  /// Permanently delete notes
  Future<void> deleteForever(Set<int> noteIds) async {
    for (final id in noteIds) {
      await noteRepo.deleteNotePermanently(id);
    }
    loadNotes();
  }

  Future<void> moveNotesToFolder({
    required Set<int> noteIds,
    int? folderId,
  }) async {
    for (final id in noteIds) {
      await noteRepo.moveNoteToFolder(noteId: id, folderId: folderId);
    }
    loadNotes();
  }

  // ================= REMINDER =================
  Future<void> addReminderToNote({
    required int noteId,
    required DateTime remindAt,
  }) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final reminder = ReminderEntity(
      noteId: noteId,
      remindAt: remindAt,
      notificationId: notificationId,
    );

    // 1️⃣ LƯU DB TRƯỚC (QUAN TRỌNG)
    await reminderRepo.add(reminder);

    // 2️⃣ THỬ SCHEDULE – FAIL CŨNG KỆ
    try {
      await NotificationService.schedule(
        id: notificationId,
        title: 'Nhắc nhở ghi chú',
        body: '',
        time: remindAt,
      );
    } catch (e) {
      debugPrint('⚠️ schedule failed but ignore: $e');
    }

    // 3️⃣ LUÔN REFRESH UI
    await loadNotes();
  }

  Future<void> markReminderDone(int reminderId) async {
    await reminderRepo.markDone(reminderId);
    await loadNotes(); // 🔥 refresh lại meta
  }

  Future<void> deleteReminder(int reminderId) async {
    await reminderRepo.delete(reminderId);
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
