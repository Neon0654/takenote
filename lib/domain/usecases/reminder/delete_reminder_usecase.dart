import '../../repositories/reminder_repository.dart';


class DeleteReminderUseCase {
  final ReminderRepository repo;

  DeleteReminderUseCase(this.repo);

  Future<int?> call(int reminderId) async {
    return await repo.delete(reminderId);
  }
}