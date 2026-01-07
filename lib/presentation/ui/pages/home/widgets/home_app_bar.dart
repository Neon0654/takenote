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
import '../../../../../utils/share_utils.dart';

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
      title: const Text(
        'Ghi chú',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          ),
        ),
        const SortMenu(),
        PopupMenuButton<_HomeMenu>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            final routes = {
              _HomeMenu.folder: () => const FolderListPage(),
              _HomeMenu.tag: () => const TagManagementPage(),
              _HomeMenu.trash: () => const TrashPage(),
            };
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => routes[value]!()),
            );
          },
          itemBuilder: (_) => [
            _buildMenuItem(
              _HomeMenu.folder,
              Icons.folder_open_rounded,
              'Thư mục',
            ),
            _buildMenuItem(_HomeMenu.tag, Icons.label_outline_rounded, 'Nhãn'),
            _buildMenuItem(
              _HomeMenu.trash,
              Icons.delete_outline_rounded,
              'Thùng rác',
            ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<_HomeMenu> _buildMenuItem(
    _HomeMenu value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

class _SelectionAppBar extends StatelessWidget {
  final SelectionState selection;
  const _SelectionAppBar({Key? key, required this.selection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () => context.read<SelectionCubit>().clear(),
      ),
      title: Text(
        '${selection.selectedIds.length} đã chọn',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
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
        IconButton(
          icon: const Icon(Icons.label_outline_rounded),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await showDialog(
                    context: context,
                    builder: (_) =>
                        MultiNoteTagDialog(noteIds: selection.selectedIds),
                  );
                  context.read<NoteCubit>().loadNotes();
                  context.read<SelectionCubit>().clear();
                },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          color: Colors.redAccent,
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  final ids = Set<int>.from(selection.selectedIds);

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Xác nhận'),
                        content: Text(
                          'Đưa ${ids.length} ghi chú vào thùng rác?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Đưa vào thùng rác'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm != true) return;

                  await context.read<NoteCubit>().deleteNotes(ids);
                  context.read<SelectionCubit>().clear();
                },
        ),

        IconButton(
          icon: const Icon(Icons.share),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () {
                  final state = context.read<NoteCubit>().state;
                  if (state is NoteLoaded) {
                    final selectedNotes = state.notes
                        .where((e) => selection.selectedIds.contains(e.note.id))
                        .map((e) => e.note)
                        .toList();

                    ShareUtils.shareMultipleNotes(selectedNotes);
                  }
                },
        ),
      ],
    );
  }
}

enum _HomeMenu { folder, tag, trash }
