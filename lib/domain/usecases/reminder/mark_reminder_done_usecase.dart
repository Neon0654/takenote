import '../../repositories/reminder_repository.dart';


class MarkReminderDoneUseCase {
  final ReminderRepository repo;

  MarkReminderDoneUseCase(this.repo);

  Future<void> call(int reminderId) async {
    await repo.markDone(reminderId);
  }
}