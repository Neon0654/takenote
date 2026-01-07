import '../../../database/notes_database.dart';
import '../../../models/reminder_model.dart';
import 'reminder_local_datasource.dart';

class ReminderLocalDataSourceImpl
    implements ReminderLocalDataSource {
  final NotesDatabase db;

  ReminderLocalDataSourceImpl(this.db);

  @override
  Future<void> createReminder(ReminderModel reminder) {
    return db.createReminder(reminder);
  }

  @override
  Future<List<ReminderModel>> getRemindersOfNote(int noteId) {
    return db.getRemindersOfNote(noteId);
  }

  @override
  Future<int?> deleteReminder(int reminderId) {
    return db.deleteReminder(reminderId);
  }

  @override
  Future<void> markReminderDone(int reminderId) {
    return db.markReminderDone(reminderId);
  }
}
