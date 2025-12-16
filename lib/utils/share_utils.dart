import 'package:share_plus/share_plus.dart';
import '../data/models/note.dart';

class ShareUtils {
  static Future<void> shareNoteToZalo(Note note) async {
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
