import '../../domain/entities/note_entity.dart';
import '../../domain/entities/attachment_entity.dart';
import '../../domain/entities/reminder_entity.dart';

class NoteViewModel {
  final NoteEntity note;
  final int attachmentCount;
  final List<AttachmentEntity> attachments;
  final List<ReminderEntity> reminders;

  NoteViewModel({
    required this.note,
    required this.attachmentCount,
    required this.attachments,
    required this.reminders,
  });

  bool get hasReminder => reminders.isNotEmpty;
}
