import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/selection/selection_cubit.dart';
import '../../../data/viewmodel/note_view_model.dart';

import 'note_item.dart';

class NoteGrid extends StatelessWidget {
  final List<NoteViewModel> notes;
  final void Function(NoteViewModel note)? onOpenNote;
  final void Function(NoteViewModel note)? onLongPressNote;

  const NoteGrid({
    super.key,
    required this.notes,
    this.onOpenNote,
    this.onLongPressNote,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('Chưa có ghi chú'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final noteVM = notes[index]; 
        final note = noteVM.note;    

        return GestureDetector(
          onLongPress: () {
            context.read<SelectionCubit>().startSelection(note.id!);
          },
          onTap: () {
            final selection = context.read<SelectionCubit>();

            if (selection.state.selecting) {
              selection.toggle(note.id!);
            } else {
              onOpenNote?.call(noteVM);
            }
          },
          child: NoteItem(
            note: note, 
            selected: context
                .watch<SelectionCubit>()
                .state
                .selectedIds
                .contains(note.id),
            attachmentCount: noteVM.attachmentCount, 
            hasReminder: noteVM.hasReminder,         
          ),
        );
      },
    );
  }
}
