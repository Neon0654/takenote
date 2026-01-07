class AttachmentEntity {
  final int? id;
  final int noteId;
  final String fileName;
  final String filePath;

  const AttachmentEntity({
    this.id,
    required this.noteId,
    required this.fileName,
    required this.filePath,
  });
}
