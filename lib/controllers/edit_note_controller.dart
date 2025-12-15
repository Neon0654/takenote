import 'dart:async';
import '../data/models/note.dart';

class EditNoteController {
  final Note note;
  final void Function(String title, String content) onSave;

  Timer? _debounce;
  bool _hasChanged = false;

  EditNoteController({
    required this.note,
    required this.onSave,
  });

  void onTextChanged({
    required String title,
    required String content,
  }) {
    _hasChanged = true;

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 600),
      () => _autoSave(title, content),
    );
  }

  void _autoSave(String title, String content) {
    if (!_hasChanged) return;
    if (title.isEmpty && content.isEmpty) return;

    onSave(title, content);
    _hasChanged = false;
  }

  /// Gọi khi back / dispose
  void forceSave(String title, String content) {
    _debounce?.cancel();

    if (title.isEmpty && content.isEmpty) return;
    onSave(title, content);
  }

  void dispose() {
    _debounce?.cancel();
  }
}
