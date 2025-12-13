import 'package:flutter/material.dart';

import '../data/database/notes_database.dart';
import '../data/models/note.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/edit_note_page.dart';

class NotesController extends StatefulWidget {
  const NotesController({super.key});

  @override
  State<NotesController> createState() => _NotesControllerState();
}

class _NotesControllerState extends State<NotesController> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  /// Load tất cả ghi chú
  Future<void> loadNotes() async {
    notes = await NotesDatabase.instance.fetchNotes();
    setState(() {});
  }

  /// Thêm ghi chú
  Future<void> addNote(String title, String content) async {
    await NotesDatabase.instance.createNote(
      Note(title: title, content: content, createdAt: DateTime.now()),
    );
    loadNotes();
  }

  /// Cập nhật ghi chú
  Future<void> updateNote(int id, String title, String content) async {
    await NotesDatabase.instance.updateNote(
      Note(id: id, title: title, content: content, createdAt: DateTime.now()),
    );
    loadNotes();
  }

  /// Xóa ghi chú
  Future<void> deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
    loadNotes();
  }

  /// ➕ Mở trang THÊM ghi chú
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

  /// ✏️ Mở trang SỬA ghi chú
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
      onDeleteNote: deleteNote,
      onAddNote: openAddNotePage,   // ✅ mở trang add
      onTapNote: openEditNotePage,  // ✅ mở đúng note
    );
  }
}
