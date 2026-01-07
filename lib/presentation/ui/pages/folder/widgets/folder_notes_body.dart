import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/domain/entities/tag_entity.dart';
import '../../../widgets/tag_bar.dart';
import '../../../widgets/note_grid.dart';
import '../../../../cubits/tag/tag_cubit.dart';
import '../../../../cubits/tag/tag_state.dart';
import '../../../../cubits/note/note_cubit.dart';
import '../../../../cubits/note/note_state.dart';

class FolderBody extends StatelessWidget {
  final int folderId;
  final void Function(dynamic noteVM) onOpenNote;

  const FolderBody({Key? key, required this.folderId, required this.onOpenNote})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, noteState) {
        if (noteState is NoteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (noteState is NoteLoaded) {
          final notes = noteState.notes;
          final selectedTagId = noteState.selectedTagId;

          return Column(
            children: [
              BlocBuilder<TagCubit, TagState>(
                builder: (context, tagState) {
                  final List<TagEntity> tags = tagState is TagLoaded
                      ? tagState.tags
                      : const <TagEntity>[];
                  return TagBar(tags: tags, selectedTagId: selectedTagId);
                },
              ),
              Expanded(
                child: NoteGrid(notes: notes, onOpenNote: onOpenNote),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
