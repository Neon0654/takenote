import 'dart:async';
import '../data/database/notes_database.dart';
import '../data/models/note.dart';

class EditNoteController {
  final Note note;
  Timer? _debounce;
  bool _hasChanged = false;

  EditNoteController(this.note);

  void onTextChanged({
    required String title,
    required String content,
  }) {
    _hasChanged = true;

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 700),
      () => _autoSave(title, content),
    );
  }

  Future<void> _autoSave(String title, String content) async {
    if (!_hasChanged) return;

    final updatedNote = Note(
      id: note.id,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    await NotesDatabase.instance.updateNote(updatedNote);
    _hasChanged = false;
  }

  Future<void> dispose(String title, String content) async {
    _debounce?.cancel();
    await _autoSave(title, content);
  }
}
