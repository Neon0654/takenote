import '../../repositories/reminder_repository.dart';

/// Deletes a reminder and returns the associated notification id (if any).
class DeleteReminderUseCase {
  final ReminderRepository repo;

  DeleteReminderUseCase(this.repo);

  Future<int?> call(int reminderId) async {
    return await repo.delete(reminderId);
  }
}