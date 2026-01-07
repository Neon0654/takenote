import '../../../../domain/entities/attachment_entity.dart';

abstract class AttachmentRepository {
  Future<void> add(AttachmentEntity attachment);
  Future<List<AttachmentEntity>> getByNote(int noteId);
  Future<void> delete(int id);
  Future<int> countByNote(int noteId);
}
