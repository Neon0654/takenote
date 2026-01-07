import '../../../database/notes_database.dart';
import '../../../models/attachment_model.dart';
import 'attachment_local_datasource.dart';

class AttachmentLocalDataSourceImpl
    implements AttachmentLocalDataSource {
  final NotesDatabase db;

  AttachmentLocalDataSourceImpl(this.db);

  @override
  Future<void> addAttachment(AttachmentModel attachment) {
    return db.addAttachment(attachment);
  }

  @override
  Future<List<AttachmentModel>> getAttachmentsOfNote(int noteId) {
    return db.getAttachmentsOfNote(noteId);
  }

  @override
  Future<void> deleteAttachment(int id) {
    return db.deleteAttachment(id);
  }

  @override
  Future<int> countAttachmentsOfNote(int noteId) {
    return db.countAttachmentsOfNote(noteId);
  }
}
