import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/tag/tag_cubit.dart';
import '../../cubits/tag/tag_state.dart';

class TagSelectorDialog extends StatefulWidget {
  final int noteId;

  const TagSelectorDialog({
    super.key,
    required this.noteId,
  });

  @override
  State<TagSelectorDialog> createState() => _TagSelectorDialogState();
}

class _TagSelectorDialogState extends State<TagSelectorDialog> {
  final Set<int> _selectedTagIds = {};

  @override
  void initState() {
    super.initState();
    _loadNoteTags();
  }

  Future<void> _loadNoteTags() async {
    final tags = await context.read<TagCubit>().getTagsOfNote(widget.noteId);

    setState(() {
      _selectedTagIds.addAll(tags.map((e) => e.id!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gắn nhãn'),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocBuilder<TagCubit, TagState>(
          builder: (context, state) {
            if (state is TagLoading || state is TagInitial) {
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
                    onChanged: (value) async {
                      if (value == true) {
                        await context.read<TagCubit>().addTagToNote(
                              noteId: widget.noteId,
                              tagId: tag.id!,
                            );
                        _selectedTagIds.add(tag.id!);
                      } else {
                        await context.read<TagCubit>().removeTagFromNote(
                              noteId: widget.noteId,
                              tagId: tag.id!,
                            );
                        _selectedTagIds.remove(tag.id!);
                      }

                      setState(() {});
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
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}
