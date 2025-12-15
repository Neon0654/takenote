import 'package:flutter/material.dart';

import '../data/database/notes_database.dart';
import '../data/models/note.dart';
import '../data/models/tag.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/edit_note_page.dart';

class NotesController extends StatefulWidget {
  const NotesController({super.key});

  @override
  State<NotesController> createState() => _NotesControllerState();
}

class _NotesControllerState extends State<NotesController> {
  List<Note> notes = [];
  Map<int, List<Tag>> noteTags = {}; // cache tag cho từng note

  List<Tag> allTags = [];
  Tag? selectedTag;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  /// LOAD NOTES + TAG
  Future<void> loadNotes() async {
    if (selectedTag == null) {
      notes = await NotesDatabase.instance.fetchNotes();
    } else {
      notes = await NotesDatabase.instance
          .getNotesByTag(selectedTag!.id!);
    }

    allTags = await NotesDatabase.instance.fetchTags();
    await loadTagsForNotes();
    setState(() {});
  }

  /// LOAD TAG CHO TẤT CẢ NOTE (PHỤC VỤ HIỂN THỊ)
  Future<void> loadTagsForNotes() async {
    noteTags.clear();

    for (final note in notes) {
      if (note.id == null) continue;
      final tags =
          await NotesDatabase.instance.getTagsOfNote(note.id!);
      noteTags[note.id!] = tags;
    }
  }

  /// CHỌN TAG
  void onSelectTag(Tag? tag) {
    selectedTag = tag;
    loadNotes();
  }

  /// ADD NOTE
  Future<void> addNote(String title, String content) async {
    await NotesDatabase.instance.createNote(
      Note(
        title: title,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
    loadNotes();
  }

  /// UPDATE NOTE
  Future<void> updateNote(int id, String title, String content) async {
    final old = await NotesDatabase.instance.getNoteById(id);
    if (old == null) return;

    await NotesDatabase.instance.updateNote(
      Note(
        id: id,
        title: title,
        content: content,
        createdAt: old.createdAt,
        isPinned: old.isPinned,
      ),
    );
    loadNotes();
  }

  /// DELETE NOTE
  Future<void> deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
    loadNotes();
  }

  /// TOGGLE PIN
  Future<void> togglePin(Note note) async {
    await NotesDatabase.instance.updateNote(
      Note(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        isPinned: !note.isPinned,
      ),
    );
    loadNotes();
  }

  /// ADD PAGE
  void openAddNotePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNotePage(
          onSave: (title, content) {
            addNote(title, content);
          },
        ),
      ),
    );
  }

  /// EDIT PAGE
  void openEditNotePage(int id) async {
    final note = await NotesDatabase.instance.getNoteById(id);
    if (note == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNotePage(
          note: note,
          onSave: (title, content) {
            updateNote(note.id!, title, content);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      notes: notes,
      noteTags: noteTags,
      tags: allTags,
      selectedTag: selectedTag,
      onSelectTag: onSelectTag,
      onAddNote: openAddNotePage,
      onDeleteNote: deleteNote,
      onTapNote: openEditNotePage,
      onTogglePin: togglePin,
    );
  }
}
