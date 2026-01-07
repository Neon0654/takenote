import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/selection/selection_cubit.dart';
import '../../../../cubits/selection/selection_state.dart';
import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';


class FolderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String folderName;
  final int folderId;

  const FolderAppBar({
    Key? key,
    required this.folderName,
    required this.folderId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, selection) {
        if (!selection.selecting) {
          return AppBar(
            elevation: 0,
            title: Text(
              folderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }

        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.read<SelectionCubit>().clear(),
          ),
          title: Text('${selection.selectedIds.length} đã chọn'),
          actions: [
            IconButton(
              icon: const Icon(Icons.select_all_rounded),
              onPressed: () {
                final state = context.read<NoteCubit>().state;
                if (state is NoteLoaded) {
                  context.read<SelectionCubit>().selectAll(
                    state.notes.map((e) => e.note.id!).toList(),
                  );
                }
              },
            ),
            PopupMenuButton<_NoteAction>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                final ids = context.read<SelectionCubit>().state.selectedIds;
                final noteCubit = context.read<NoteCubit>();
                if (value == _NoteAction.moveOut) {
                  await noteCubit.moveNotesToFolder(
                    noteIds: ids,
                    folderId: null,
                  );
                } else {
                  await noteCubit.deleteNotes(ids);
                }
                noteCubit.showFolder(folderId);
                context.read<SelectionCubit>().clear();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _NoteAction.moveOut,
                  child: Row(
                    children: [
                      Icon(Icons.outbox_rounded),
                      SizedBox(width: 12),
                      Text('Chuyển ra ngoài'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: _NoteAction.delete,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Xóa', style: TextStyle(color: Colors.red)),
                    ],
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
