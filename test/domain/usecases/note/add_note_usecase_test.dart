import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes/domain/repositories/note_repository.dart';
import 'package:notes/domain/usecases/note/add_note_usecase.dart';
import 'package:notes/domain/entities/note_entity.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

class FakeNote extends Fake implements NoteEntity {}

void main() {
  late MockNoteRepository mockRepo;
  late AddNoteUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeNote());
  });

  setUp(() {
    mockRepo = MockNoteRepository();
    useCase = AddNoteUseCase(mockRepo);
  });

  group('AddNoteUseCase', () {
    test('calls noteRepo.addNote with NoteEntity containing title and content and folderId when provided', () async {
      // Arrange
      when(() => mockRepo.addNote(any(), folderId: 7)).thenAnswer((inv) async {
        final note = inv.positionalArguments[0] as NoteEntity;
        expect(note.title, 'My Title');
        expect(note.content, 'My Content');
        expect(note.isDeleted, isFalse);
        expect(note.isPinned, isFalse);
        return 1;
      });

      // Act
      await useCase.call(title: 'My Title', content: 'My Content', folderId: 7);

      // Assert
      verify(() => mockRepo.addNote(any(), folderId: 7)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('works when folderId is omitted (null)', () async {
      // Arrange
      when(() => mockRepo.addNote(any(), folderId: null)).thenAnswer((inv) async {
        final note = inv.positionalArguments[0] as NoteEntity;
        expect(note.title, 'T');
        expect(note.content, 'C');
        return 1;
      });

      // Act
      await useCase.call(title: 'T', content: 'C');

      // Assert
      verify(() => mockRepo.addNote(any(), folderId: null)).called(1);
    });

    test('propagates exceptions from repository', () async {
      // Arrange
      when(() => mockRepo.addNote(any(), folderId: null)).thenThrow(Exception('db')); 

      // Act & Assert
      expect(() => useCase.call(title: 'x', content: 'y'), throwsA(isA<Exception>()));
      verify(() => mockRepo.addNote(any(), folderId: null)).called(1);
    });
  });
}
