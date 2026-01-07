import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/folder/folder_cubit.dart';
import '../../../../cubits/folder/folder_state.dart';

import '../../../../../domain/entities/folder_entity.dart';
import '../../folder/folder_notes_page.dart';


import '../dialogs/rename_folder_dialog.dart';
import '../dialogs/delete_folder_confirm_dialog.dart';

class FolderListBody extends StatelessWidget {
  const FolderListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) {
        if (state is FolderLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is FolderError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }

        if (state is FolderLoaded) {
          if (state.folders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Chưa có thư mục', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.folders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(folder.colorValue).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.folder_rounded, color: Color(folder.colorValue)),
        ),
        title: Text(folder.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$count ghi chú', style: TextStyle(color: Colors.grey[600])),
        trailing: PopupMenuButton<_FolderMenu>(
          icon: const Icon(Icons.more_vert_rounded),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == _FolderMenu.rename) _showRenameDialog(context);
            if (value == _FolderMenu.delete) _confirmDelete(context);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: _FolderMenu.rename,
              child: Row(children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 12), Text('Đổi tên')]),
            ),
            const PopupMenuItem(
              value: _FolderMenu.delete,
              child: Row(children: [Icon(Icons.delete_outline, size: 20, color: Colors.red), SizedBox(width: 12), Text('Xóa', style: TextStyle(color: Colors.red))]),
            ),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FolderNotesPage(folder: folder))),
      ),
    );
  }

  void _showRenameDialog(BuildContext context) => showDialog(context: context, builder: (_) => RenameFolderDialog(folderId: folder.id!, initialName: folder.name));
  void _confirmDelete(BuildContext context) => showDialog(context: context, builder: (_) => DeleteFolderConfirmDialog(folderId: folder.id!, folderName: folder.name));
}

enum _FolderMenu { rename, delete }
