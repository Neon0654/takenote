import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/note/note_state.dart';

import '../../../cubits/selection/selection_cubit.dart';
import '../../../cubits/selection/selection_state.dart';

import '../../../ui/widgets/note_grid.dart';

class SelectNotesPage extends StatelessWidget {
  final int? targetFolderId;

  const SelectNotesPage({super.key, this.targetFolderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NoteLoaded) {
            return NoteGrid(notes: state.notes);
          }

          return const SizedBox();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, selection) {
          // ===== NORMAL MODE =====
          if (!selection.selecting) {
            return AppBar(title: const Text('Chọn ghi chú'));
          }

          // ===== SELECTION MODE =====
          final selectedCount = selection.selectedIds.length;

          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<SelectionCubit>().clear();
              },
            ),
            title: Text('$selectedCount đã chọn'),
            actions: [
              // ☑️ Select all
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

              // ✅ CONFIRM
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: selectedCount == 0
                    ? null
                    : () async {
                        final ids = context
                            .read<SelectionCubit>()
                            .state
                            .selectedIds;

                        await context.read<NoteCubit>().moveNotesToFolder(
                          noteIds: ids,
                          folderId: targetFolderId,
                        );

                        Navigator.pop(context, true);
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
