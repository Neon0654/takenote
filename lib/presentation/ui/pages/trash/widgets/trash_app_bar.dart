import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/selection/selection_cubit.dart';
import '../../../../cubits/selection/selection_state.dart';
import '../../../../cubits/note/note_cubit.dart';

class TrashAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrashAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, selection) {
        return selection.selecting
            ? _buildSelectionAppBar(context, selection)
            : _buildNormalAppBar();
      },
    );
  }

  PreferredSizeWidget _buildNormalAppBar() => AppBar(title: const Text('Thùng rác'));

  PreferredSizeWidget _buildSelectionAppBar(
    BuildContext context,
    SelectionState selection,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.read<SelectionCubit>().clear(),
      ),
      title: Text('${selection.selectedIds.length} đã chọn'),
      actions: [
        IconButton(
          icon: const Icon(Icons.restore_from_trash),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await context.read<NoteCubit>().restoreNotes(
                        selection.selectedIds,
                      );
                  context.read<SelectionCubit>().clear();
                },
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Xóa vĩnh viễn'),
                      content: const Text(
                        'Bạn có chắc chắn muốn xóa vĩnh viễn các ghi chú đã chọn?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await context.read<NoteCubit>().deleteForever(
                          selection.selectedIds,
                        );
                    context.read<SelectionCubit>().clear();
                  }
                },
        ),
      ],
    );
  }
}
