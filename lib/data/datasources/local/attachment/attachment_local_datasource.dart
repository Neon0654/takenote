import '../../../models/attachment_model.dart';

abstract class AttachmentLocalDataSource {
  Future<void> addAttachment(AttachmentModel attachment);
  Future<List<AttachmentModel>> getAttachmentsOfNote(int noteId);
  Future<void> deleteAttachment(int id);
  Future<int> countAttachmentsOfNote(int noteId);
}
