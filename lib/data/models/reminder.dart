class Reminder {
  final int? id;
  final int noteId;
  final DateTime remindAt;
  final bool isDone;
  final int notificationId;

  Reminder({
    this.id,
    required this.noteId,
    required this.remindAt,
    this.isDone = false,
    required this.notificationId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'noteId': noteId,
        'remindAt': remindAt.toIso8601String(),
        'isDone': isDone ? 1 : 0,
        'notificationId': notificationId,
      };

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      noteId: map['noteId'],
      remindAt: DateTime.parse(map['remindAt']),
      isDone: map['isDone'] == 1,
      notificationId: map['notificationId'],
    );
  }
}
