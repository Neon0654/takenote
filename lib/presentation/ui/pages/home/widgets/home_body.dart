import 'package:flutter/material.dart';
import 'package:notes/data/viewmodel/note_view_model.dart';
import 'package:notes/domain/entities/tag_entity.dart';

import '../../../widgets/tag_bar.dart';
import '../../../widgets/note_grid.dart';


class HomeBody extends StatelessWidget {
  final List<NoteViewModel> notes;
  final List<TagEntity> tags;
  final int? selectedTagId;
  final int? folderId;
  final ValueChanged<NoteViewModel> onOpenNote;

  const HomeBody({
    Key? key,
    required this.notes,
    required this.tags,
    required this.selectedTagId,
    required this.folderId,
    required this.onOpenNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TagBar(tags: tags, selectedTagId: selectedTagId),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 24, thickness: 1),
        ),
        Expanded(
          child: NoteGrid(notes: notes, onOpenNote: onOpenNote),
        ),
      ],
    );
  }
}
