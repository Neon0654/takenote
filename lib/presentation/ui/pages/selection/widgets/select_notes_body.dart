import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';
import '../../../widgets/note_grid.dart';

class SelectNotesBody extends StatelessWidget {
  const SelectNotesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoteLoaded) {
          return NoteGrid(notes: state.notes);
        }

        return const SizedBox();
      },
    );
  }
}
