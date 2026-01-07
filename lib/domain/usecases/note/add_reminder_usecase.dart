import '../../entities/reminder_entity.dart';
import '../../repositories/reminder_repository.dart';
import '../../../../services/notification_service.dart';

/// Adds a reminder and schedules a notification. Moved from cubit.
class AddReminderUseCase {
  final ReminderRepository reminderRepo;

  AddReminderUseCase(this.reminderRepo);

  Future<void> call({required int noteId, required DateTime remindAt}) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final reminder = ReminderEntity(
      noteId: noteId,
      remindAt: remindAt,
      notificationId: notificationId,
    );

    // Persist reminder first (same ordering as before)
    await reminderRepo.add(reminder);

    // schedule, but swallow errors as before
    try {
      await NotificationService.schedule(
        id: notificationId,
        title: 'Nhắc nhở ghi chú',
        body: '',
        time: remindAt,
      );
    } catch (e) {
      // keep warning consistent
    }
  }
}
