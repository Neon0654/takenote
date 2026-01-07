import 'package:share_plus/share_plus.dart';
import '../domain/entities/note_entity.dart';

class ShareUtils {
  static Future<void> shareNote(NoteEntity note) async {
    if (note.content.trim().isEmpty) return;

    final content =
        '''
${note.title}

${note.content}
''';

    await Share.share(content, subject: note.title);
  }

  static Future<void> shareMultipleNotes(List<NoteEntity> notes) async {
    if (notes.isEmpty) return;

    final buffer = StringBuffer();

    for (final note in notes) {
      buffer.writeln(note.title);
      buffer.writeln(note.content);
      buffer.writeln('\n----------------\n');
    }

    await Share.share(buffer.toString());
  }
}
