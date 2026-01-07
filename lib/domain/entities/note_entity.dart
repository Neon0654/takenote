import 'tag_entity.dart';

class NoteEntity {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt; // 🔧 new field: last updated timestamp
  final bool isPinned;
  final bool isDeleted;
  final List<TagEntity> tags;

  const NoteEntity({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    this.isDeleted = false,
    this.tags = const [],
  }) : updatedAt = updatedAt ?? createdAt; // default updatedAt = createdAt

  NoteEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isDeleted,
    List<TagEntity>? tags,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isDeleted: isDeleted ?? this.isDeleted,
      tags: tags ?? this.tags,
    );
  }
}
