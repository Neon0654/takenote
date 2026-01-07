import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../domain/repositories/folder_repository.dart';
import 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  final FolderRepository repo;

  FolderCubit(this.repo) : super(FolderLoading());

  Future<void> loadFolders() async {
    try {
      emit(FolderLoading());
      final folders = await repo.getFolders();
      emit(FolderLoaded(folders, {}));
    } catch (e) {
      emit(FolderError(e.toString()));
    }
  }

  Future<void> createFolder(String name, int color) async {
    if (name.trim().isEmpty) return;
    await repo.createFolder(
      FolderEntity(
        name: name.trim(),
        colorValue: color,
        createdAt: DateTime.now(),
      ),
    );
    loadFolders();
  }

  Future<void> renameFolder(int id, String newName) async {
    if (newName.trim().isEmpty) return;
    await repo.renameFolder(id, newName.trim());
    loadFolders();
  }

  Future<void> deleteFolder(int id) async {
    await repo.deleteFolder(id);
    loadFolders();
  }
}
