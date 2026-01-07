class ReminderEntity {
  final int? id;
  final int noteId;
  final DateTime remindAt;
  final bool isDone;
  final int notificationId;

  const ReminderEntity({
    this.id,
    required this.noteId,
    required this.remindAt,
    this.isDone = false,
    required this.notificationId,
  });
}
