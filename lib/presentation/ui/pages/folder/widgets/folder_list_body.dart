import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/folder/folder_cubit.dart';
import '../../../../cubits/folder/folder_state.dart';

import '../../../../../domain/entities/folder_entity.dart';
import '../../folder/folder_notes_page.dart';

// Dialogs
import '../dialogs/rename_folder_dialog.dart';
import '../dialogs/delete_folder_confirm_dialog.dart';

class FolderListBody extends StatelessWidget {
  const FolderListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) {
        if (state is FolderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FolderError) {
          return Center(child: Text(state.message));
        }

        if (state is FolderLoaded) {
          if (state.folders.isEmpty) {
            return const Center(child: Text('Chưa có thư mục'));
          }

          return ListView.builder(
            itemCount: state.folders.length,
            itemBuilder: (_, index) {
              final folder = state.folders[index];
              final count = state.noteCount[folder.id] ?? 0;

              return _FolderTile(folder: folder, count: count);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _FolderTile extends StatelessWidget {
  final FolderEntity folder;
  final int count;

  const _FolderTile({required this.folder, required this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.folder, color: Color(folder.colorValue)),
      title: Text(folder.name),
      subtitle: Text('$count ghi chú'),

      trailing: PopupMenuButton<_FolderMenu>(
        onSelected: (value) {
          switch (value) {
            case _FolderMenu.rename:
              _showRenameDialog(context);
              break;
            case _FolderMenu.delete:
              _confirmDelete(context);
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: _FolderMenu.rename,
            child: ListTile(leading: Icon(Icons.edit), title: Text('Đổi tên')),
          ),
          PopupMenuItem(
            value: _FolderMenu.delete,
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa'),
            ),
          ),
        ],
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FolderNotesPage(folder: folder)),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => RenameFolderDialog(folderId: folder.id!, initialName: folder.name),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteFolderConfirmDialog(folderId: folder.id!, folderName: folder.name),
    );
  }
}

enum _FolderMenu { rename, delete }
