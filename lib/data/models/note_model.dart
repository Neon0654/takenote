import '../../domain/entities/note_entity.dart';

class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;
  final bool isDeleted;
  final int? folderId;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.isDeleted = false,
    this.folderId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isPinned': isPinned ? 1 : 0,
        'isDeleted': isDeleted ? 1 : 0,
        'folderId': folderId,
      };

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isPinned: map['isPinned'] == 1,
      isDeleted: map['isDeleted'] == 1,
      folderId: map['folderId'],
    );
  }

  NoteEntity toEntity() => NoteEntity(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
        isPinned: isPinned,
        isDeleted: isDeleted,
      );
}
