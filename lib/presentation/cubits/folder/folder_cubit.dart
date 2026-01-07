import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/folder_repository.dart';

import '../../../domain/usecases/folder/get_folders_usecase.dart';
import '../../../domain/usecases/folder/create_folder_usecase.dart';
import '../../../domain/usecases/folder/rename_folder_usecase.dart';
import '../../../domain/usecases/folder/delete_folder_usecase.dart';
import '../../../domain/usecases/folder/count_notes_by_folder_usecase.dart';

import 'folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  final FolderRepository repo;

  final GetFoldersUseCase getFoldersUseCase;
  final CreateFolderUseCase createFolderUseCase;
  final RenameFolderUseCase renameFolderUseCase;
  final DeleteFolderUseCase deleteFolderUseCase;
  final CountNotesByFolderUseCase countNotesByFolderUseCase;


  FolderCubit(
    this.repo, {
    GetFoldersUseCase? getFoldersUseCase,
    CreateFolderUseCase? createFolderUseCase,
    RenameFolderUseCase? renameFolderUseCase,
    DeleteFolderUseCase? deleteFolderUseCase,
    CountNotesByFolderUseCase? countNotesByFolderUseCase,
  })  : getFoldersUseCase = getFoldersUseCase ?? GetFoldersUseCase(repo),
        createFolderUseCase = createFolderUseCase ?? CreateFolderUseCase(repo),
        renameFolderUseCase = renameFolderUseCase ?? RenameFolderUseCase(repo),
        deleteFolderUseCase = deleteFolderUseCase ?? DeleteFolderUseCase(repo),
        countNotesByFolderUseCase = countNotesByFolderUseCase ?? CountNotesByFolderUseCase(repo),
        super(FolderLoading());

  Future<void> loadFolders() async {
    try {
      emit(FolderLoading());
      final folders = await getFoldersUseCase.call();
      final noteCount = await countNotesByFolderUseCase.call();
      emit(FolderLoaded(folders, noteCount));
    } catch (e) {
      emit(FolderError(e.toString()));
    }
  }

  Future<void> createFolder(String name, int color) async {
    await createFolderUseCase.call(name: name, color: color);
    loadFolders();
  }

  Future<void> renameFolder(int id, String newName) async {
    await renameFolderUseCase.call(id: id, newName: newName);
    loadFolders();
  }

  Future<void> deleteFolder(int id) async {
    await deleteFolderUseCase.call(id);
    loadFolders();
  }
}
