import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';
import '../../../../ui/widgets/note_grid.dart';

class TrashBody extends StatelessWidget {
  const TrashBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
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
            onOpenNote: (_) {}, 
          );
        }

        return const SizedBox();
      },
    );
  }
}
