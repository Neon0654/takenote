import '../../domain/entities/reminder_entity.dart';

class ReminderModel {
  final int? id;
  final int noteId;
  final DateTime remindAt;
  final bool isDone;
  final int notificationId;

  ReminderModel({
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

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      noteId: map['noteId'],
      remindAt: DateTime.parse(map['remindAt']),
      isDone: map['isDone'] == 1,
      notificationId: map['notificationId'],
    );
  }

  ReminderEntity toEntity() => ReminderEntity(
    id: id,
    noteId: noteId,
    remindAt: remindAt,
    isDone: isDone,
    notificationId: notificationId,
  );

  factory ReminderModel.fromEntity(ReminderEntity entity) {
    return ReminderModel(
      id: entity.id,
      noteId: entity.noteId,
      remindAt: entity.remindAt,
      isDone: entity.isDone,
      notificationId: entity.notificationId,
    );
  }
}
