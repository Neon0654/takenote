import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/domain/repositories/reminder_repository.dart';
import 'package:notes/domain/usecases/reminder/mark_reminder_done_usecase.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  late MockReminderRepository mockRepo;
  late MarkReminderDoneUseCase useCase;

  setUp(() {
    mockRepo = MockReminderRepository();
    useCase = MarkReminderDoneUseCase(mockRepo);
  });

  group('MarkReminderDoneUseCase', () {
    test('calls repository.markDone with correct reminderId', () async {
      // Arrange
      when(() => mockRepo.markDone(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(42);

      // Assert
      verify(() => mockRepo.markDone(42)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('propagates exceptions thrown by repository', () async {
      // Arrange
      when(() => mockRepo.markDone(any())).thenThrow(Exception('db error'));

      // Act & Assert
      expect(() => useCase.call(7), throwsA(isA<Exception>()));
      verify(() => mockRepo.markDone(7)).called(1);
    });
  });
}
