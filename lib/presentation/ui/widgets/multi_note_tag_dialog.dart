import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/tag/tag_cubit.dart';
import '../../cubits/tag/tag_state.dart';

import '../../../domain/repositories/tag_repository.dart';

class MultiNoteTagDialog extends StatefulWidget {
  final Set<int> noteIds;

  const MultiNoteTagDialog({super.key, required this.noteIds});

  @override
  State<MultiNoteTagDialog> createState() => _MultiNoteTagDialogState();
}

class _MultiNoteTagDialogState extends State<MultiNoteTagDialog> {
  final Set<int> _selectedTagIds = {};
  final Set<int> _existingTagIds = {};

  @override
  void initState() {
    super.initState();
    _loadExistingTags();
  }

  Future<void> _loadExistingTags() async {
    // Lấy 1 note đại diện (vì dialog này là UI)
    final noteId = widget.noteIds.first;

    final tagRepo = context.read<TagRepository>();

    final tags = await tagRepo.getTagsOfNote(noteId);

    setState(() {
      final ids = tags.map((e) => e.id!).toSet();
      _existingTagIds.addAll(ids);
      _selectedTagIds.addAll(ids);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Gắn nhãn (${widget.noteIds.length} ghi chú)'),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocBuilder<TagCubit, TagState>(
          builder: (context, state) {
            if (state is TagInitial || state is TagLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TagLoaded) {
              return ListView(
                shrinkWrap: true,
                children: state.tags.map((tag) {
                  final checked = _selectedTagIds.contains(tag.id);

                  return CheckboxListTile(
                    title: Text(tag.name),
                    value: checked,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTagIds.add(tag.id!);
                        } else {
                          _selectedTagIds.remove(tag.id!);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }

            if (state is TagError) {
              return Text(state.message);
            }

            return const SizedBox();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _selectedTagIds.isEmpty
              ? null
              : () async {
                  final tagCubit = context.read<TagCubit>();

                  for (final noteId in widget.noteIds) {
                    for (final tagId in _selectedTagIds) {
                      await tagCubit.addTagToNote(noteId: noteId, tagId: tagId);
                    }
                    for (final tagId in _existingTagIds.difference(
                      _selectedTagIds,
                    )) {
                      await tagCubit.removeTagFromNote(
                        noteId: noteId,
                        tagId: tagId,
                      );
                    }
                  }

                  Navigator.pop(context);
                },
          child: const Text('Gắn'),
        ),
      ],
    );
  }
}
