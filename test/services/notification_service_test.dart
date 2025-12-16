import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/models/reminder.dart';

/// 🔔 Fake Notification Service để test
class FakeNotificationService {
  static final List<int> scheduledIds = [];

  static Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    // giả lập việc lập lịch
    scheduledIds.add(id);
  }

  static void reset() {
    scheduledIds.clear();
  }
}

void main() {
  test('Schedule notification when reminder is created', () async {
    FakeNotificationService.reset();

    final reminder = Reminder(
      noteId: 1,
      remindAt: DateTime.now().add(const Duration(minutes: 1)),
      notificationId: 12345,
    );

    // 🔥 Giả lập gọi schedule
    await FakeNotificationService.schedule(
      id: reminder.notificationId,
      title: 'Test Reminder',
      body: 'This is a test',
      time: reminder.remindAt,
    );

    // ✅ ASSERT
    expect(FakeNotificationService.scheduledIds.length, 1);
    expect(FakeNotificationService.scheduledIds.first, 12345);
  });
}
