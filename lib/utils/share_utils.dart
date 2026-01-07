import 'package:share_plus/share_plus.dart';
import '../data/models/note_model.dart';

class ShareUtils {
  static Future<void> shareNoteToZalo(NoteModel note) async {
    final content = '''
${note.title}

${note.content}
''';

    await Share.share(
      content,
      subject: note.title,
    );
  }
}
