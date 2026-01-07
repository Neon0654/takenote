import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/models/note_model.dart';

void main() {
  test('Note toMap & fromMap works correctly', () {
    final note = Note(
      id: 1,
      title: 'Test',
      content: 'Hello',
      createdAt: DateTime(2024, 1, 1),
    );

    final map = note.toMap();
    final fromMap = Note.fromMap(map);

    expect(fromMap.id, 1);
    expect(fromMap.title, 'Test');
    expect(fromMap.content, 'Hello');
    expect(fromMap.createdAt.year, 2024);
  });
}
