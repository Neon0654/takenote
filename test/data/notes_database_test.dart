import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/database/notes_database.dart';
import 'package:notes/data/models/note_model.dart';
import '../test_config.dart';

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });

  test('CREATE + READ note from SQLite', () async {
    final db = NotesDatabase.instance;

    final note = Note(
      title: 'SQL Test',
      content: 'Hello DB',
      createdAt: DateTime.now(),
    );

    final id = await db.createNote(note);
    final fetched = await db.getNoteById(id);

    expect(fetched, isNotNull);
    expect(fetched!.title, 'SQL Test');
  });

  test('UPDATE note in SQLite', () async {
    final db = NotesDatabase.instance;

    final note = Note(
      title: 'Old',
      content: 'Old',
      createdAt: DateTime.now(),
    );

    final id = await db.createNote(note);

    await db.updateNote(
      Note(
        id: id,
        title: 'New',
        content: 'New',
        createdAt: DateTime.now(),
      ),
    );

    final updated = await db.getNoteById(id);
    expect(updated!.title, 'New');
  });

  test('DELETE note in SQLite', () async {
    final db = NotesDatabase.instance;

    final id = await db.createNote(
      Note(
        title: 'Delete',
        content: 'Me',
        createdAt: DateTime.now(),
      ),
    );

    await db.deleteNote(id);
    final deleted = await db.getNoteById(id);

    expect(deleted, isNull);
  });
}
