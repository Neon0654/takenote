class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;
  final bool isDeleted; // 🔥 THÊM TRƯỜNG NÀY

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.isDeleted = false, // 🔥 DEFAULT = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0, // 🔥 MAP RA DB
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      isPinned: map['isPinned'] == 1,
      isDeleted: map['isDeleted'] == 1, // 🔥 MAP TỪ DB
    );
  }
}
