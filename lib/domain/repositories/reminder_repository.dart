import '../../../domain/entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<void> add(ReminderEntity reminder);
  Future<List<ReminderEntity>> getByNote(int noteId);
  Future<int?> delete(int reminderId);
  Future<void> markDone(int reminderId);
}

