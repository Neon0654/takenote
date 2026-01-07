import '../../../models/reminder_model.dart';

abstract class ReminderLocalDataSource {
  Future<void> createReminder(ReminderModel reminder);
  Future<List<ReminderModel>> getRemindersOfNote(int noteId);
  Future<int?> deleteReminder(int reminderId);
  Future<void> markReminderDone(int reminderId);
}
