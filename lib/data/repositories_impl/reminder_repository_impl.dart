import '../../../../services/notification_service.dart';
import '../../../domain/entities/reminder_entity.dart';
import '../../../domain/repositories/reminder_repository.dart';
import '../datasources/local/reminder/reminder_local_datasource.dart';
import '../models/reminder_model.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource local;

  ReminderRepositoryImpl(this.local);

  @override
  Future<void> add(ReminderEntity entity) async {
    await local.createReminder(
      ReminderModel.fromEntity(entity),
    );
  }

  @override
  Future<List<ReminderEntity>> getByNote(int noteId) async {
    final models = await local.getRemindersOfNote(noteId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int?> delete(int reminderId) async {
    final notificationId = await local.deleteReminder(reminderId);
    if (notificationId != null) {
      await NotificationService.cancel(notificationId);
    }
    return notificationId;
  }

  @override
  Future<void> markDone(int reminderId) {
    return local.markReminderDone(reminderId);
  }
}
