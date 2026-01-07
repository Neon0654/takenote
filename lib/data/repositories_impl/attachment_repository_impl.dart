import '../../../../domain/entities/attachment_entity.dart';
import '../../../../domain/repositories/attachment_repository.dart';
import '../datasources/local/attachment/attachment_local_datasource.dart';
import '../models/attachment_model.dart';

class AttachmentRepositoryImpl implements AttachmentRepository {
  final AttachmentLocalDataSource local;

  AttachmentRepositoryImpl(this.local);

  @override
  Future<void> add(AttachmentEntity entity) {
    return local.addAttachment(
      AttachmentModel.fromEntity(entity),
    );
  }

  @override
  Future<List<AttachmentEntity>> getByNote(int noteId) async {
    final models = await local.getAttachmentsOfNote(noteId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> countByNote(int noteId) {
    return local.countAttachmentsOfNote(noteId);
  }

  @override
  Future<void> delete(int id) {
    return local.deleteAttachment(id);
  }
}
