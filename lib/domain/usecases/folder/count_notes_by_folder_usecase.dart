import '../../repositories/folder_repository.dart';

class CountNotesByFolderUseCase {
  final FolderRepository repo;

  CountNotesByFolderUseCase(this.repo);

  Future<Map<int, int>> call() {
    return repo.getNoteCountByFolder();
  }
}
