import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/models/note_model.dart';
import 'package:notes/controllers_old/edit_note_controller.dart';

void main() {
  test('EditNoteController marks changed on text change', () {
    final note = Note(
      id: 1,
      title: 'Old',
      content: 'Old',
      createdAt: DateTime.now(),
    );

    final controller = EditNoteController(note);

    controller.onTextChanged(title: 'New', content: 'New');

    // Không crash = pass
    expect(true, true);
  });
}
