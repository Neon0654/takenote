import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/selection/selection_cubit.dart';
import '../../../../cubits/selection/selection_state.dart';
import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';

/// AppBar for folder notes page. Keeps UI logic only and dispatches cubit actions.
class FolderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String folderName;
  final int folderId;

  const FolderAppBar({Key? key, required this.folderName, required this.folderId}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, selection) {
        if (!selection.selecting) {
          return AppBar(title: Text(folderName));
        }

        final selectedCount = selection.selectedIds.length;

        return AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.read<SelectionCubit>().clear(),
          ),
          title: Text('$selectedCount đã chọn'),
          actions: [
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                final state = context.read<NoteCubit>().state;
                if (state is! NoteLoaded) return;

                context.read<SelectionCubit>().selectAll(
                  state.notes.map((e) => e.note.id!).toList(),
                );
              },
            ),
            PopupMenuButton<_NoteAction>(
              onSelected: (value) async {
                final ids = context.read<SelectionCubit>().state.selectedIds;
                final noteCubit = context.read<NoteCubit>();

                switch (value) {
                  case _NoteAction.moveOut:
                    await noteCubit.moveNotesToFolder(
                      noteIds: ids,
                      folderId: null,
                    );
                    noteCubit.showFolder(folderId);
                    break;

                  case _NoteAction.delete:
                    await noteCubit.deleteNotes(ids);
                    noteCubit.showFolder(folderId);
                    break;
                }

                context.read<SelectionCubit>().clear();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _NoteAction.moveOut,
                  child: ListTile(
                    leading: Icon(Icons.drive_file_move),
                    title: Text('Chuyển ra ngoài'),
                  ),
                ),
                PopupMenuItem(
                  value: _NoteAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Xóa'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

enum _NoteAction { moveOut, delete }