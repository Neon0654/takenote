import '../../domain/entities/attachment_entity.dart';

class AttachmentModel {
  final int? id;
  final int noteId;
  final String fileName;
  final String filePath;

  AttachmentModel({
    this.id,
    required this.noteId,
    required this.fileName,
    required this.filePath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'noteId': noteId,
    'fileName': fileName,
    'filePath': filePath,
  };

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'],
      noteId: map['noteId'],
      fileName: map['fileName'],
      filePath: map['filePath'],
    );
  }

  AttachmentEntity toEntity() => AttachmentEntity(
    id: id,
    noteId: noteId,
    fileName: fileName,
    filePath: filePath,
  );

  factory AttachmentModel.fromEntity(AttachmentEntity entity) {
    return AttachmentModel(
      id: entity.id,
      noteId: entity.noteId,
      fileName: entity.fileName,
      filePath: entity.filePath,
    );
  }
}
