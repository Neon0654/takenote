import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/selection/selection_cubit.dart';
import '../../../cubits/selection/selection_state.dart';
import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/note/note_state.dart';
import '../../widgets/note_grid.dart';
import '../note/note_page.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    // Load trash notes once when entering this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteCubit>().showTrash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectionCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<SelectionCubit, SelectionState>(
            builder: (context, selection) {
              if (!selection.selecting) {
                return _buildNormalAppBar(context);
              } else {
                return _buildSelectionAppBar(context, selection);
              }
            },
          ),
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteInitial || state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NoteError) {
              return Center(child: Text(state.message));
            }

            if (state is NoteLoaded) {
              return NoteGrid(
                notes: state.notes,
                onOpenNote: (noteVM) async {
                  // For simplicity keep the same open behavior as HomePage
                  // (opens the note editor). After editing, reload trash.
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotePage(note: noteVM.note),
                      ),
                    );

                    // Ensure trash is reloaded after returning
                    context.read<NoteCubit>().showTrash();
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Thùng rác'),
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(
    BuildContext context,
    SelectionState selection,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          context.read<SelectionCubit>().clear();
        },
      ),
      title: Text('${selection.selectedIds.length} đã chọn'),
      actions: [
        IconButton(
          icon: const Icon(Icons.restore_from_trash),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await context
                      .read<NoteCubit>()
                      .restoreNotes(selection.selectedIds);
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
                          'Bạn có chắc chắn muốn xóa vĩnh viễn các ghi chú đã chọn?'),
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
                    await context
                        .read<NoteCubit>()
                        .deleteForever(selection.selectedIds);
                    context.read<SelectionCubit>().clear();
                  }
                },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // When leaving trash page ensure we return to the main view
    context.read<NoteCubit>().showAll();
    super.dispose();
  }
}
