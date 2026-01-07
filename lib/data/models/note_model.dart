import '../../domain/entities/note_entity.dart';

class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt; // 🔧 new field persisted in DB
  final bool isPinned;
  final bool isDeleted;
  final int? folderId;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    this.isDeleted = false,
    this.folderId,
  }) : updatedAt = updatedAt ?? createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isPinned': isPinned ? 1 : 0,
        'isDeleted': isDeleted ? 1 : 0,
        'folderId': folderId,
      };

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    final created = DateTime.parse(map['createdAt']);
    final updated = map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'])
        : created; // fallback

    return NoteModel(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: created,
      updatedAt: updated,
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
        updatedAt: updatedAt,
        isPinned: isPinned,
        isDeleted: isDeleted,
      );
}
