import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/selection/selection_cubit.dart';
import '../../../../cubits/selection/selection_state.dart';
import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';
import '../../../widgets/multi_note_tag_dialog.dart';
import '../../folder/folder_list_page.dart';
import '../../tag/tag_manage_page.dart';
import '../../search/search_page.dart';
import '../../trash/trash_page.dart';
import 'sort_menu.dart';

/// App bar that switches between normal and selection mode.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, selection) {
        if (!selection.selecting) {
          return _NormalAppBar();
        } else {
          return _SelectionAppBar(selection: selection);
        }
      },
    );
  }
}

class _NormalAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Ghi chú'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
          },
        ),

        const SortMenu(),

        PopupMenuButton<_HomeMenu>(
          onSelected: (value) {
            switch (value) {
              case _HomeMenu.folder:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FolderListPage()));
                break;
              case _HomeMenu.tag:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TagManagementPage()));
                break;
              case _HomeMenu.trash:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TrashPage()));
                break;
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: _HomeMenu.folder, child: ListTile(leading: Icon(Icons.folder), title: Text('Thư mục'))),
            PopupMenuItem(value: _HomeMenu.tag, child: ListTile(leading: Icon(Icons.label), title: Text('Nhãn'))),
            PopupMenuItem(value: _HomeMenu.trash, child: ListTile(leading: Icon(Icons.delete), title: Text('Thùng rác'))),
          ],
        ),
      ],
    );
  }
}

class _SelectionAppBar extends StatelessWidget {
  final SelectionState selection;
  const _SelectionAppBar({Key? key, required this.selection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.read<SelectionCubit>().clear(),
      ),
      title: Text('${selection.selectedIds.length} đã chọn'),
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

        IconButton(
          icon: const Icon(Icons.label),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await showDialog(
                    context: context,
                    builder: (_) => MultiNoteTagDialog(noteIds: selection.selectedIds),
                  );

                  context.read<NoteCubit>().loadNotes();
                  context.read<SelectionCubit>().clear();
                },
        ),

        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await context.read<NoteCubit>().deleteNotes(selection.selectedIds);
                  context.read<SelectionCubit>().clear();
                },
        ),
      ],
    );
  }
}

enum _HomeMenu { folder, tag, trash }
