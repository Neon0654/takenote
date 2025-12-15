class Attachment {
  final int? id;
  final int noteId;
  final String fileName;
  final String filePath;

  Attachment({
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

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'],
      noteId: map['noteId'],
      fileName: map['fileName'],
      filePath: map['filePath'],
    );
  }
}
