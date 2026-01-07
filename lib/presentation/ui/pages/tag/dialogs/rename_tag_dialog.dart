import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/tag/tag_cubit.dart';
import '../../../../cubits/note/note_cubit.dart';

/// Dialog to rename a tag. UI-only: takes current name and submits new name.
class RenameTagDialog extends StatefulWidget {
  final int tagId;
  final String initialName;

  const RenameTagDialog({Key? key, required this.tagId, required this.initialName}) : super(key: key);

  @override
  State<RenameTagDialog> createState() => _RenameTagDialogState();
}

class _RenameTagDialogState extends State<RenameTagDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đổi tên nhãn'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Tên nhãn mới'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            final newName = _controller.text.trim();
            if (newName.isEmpty) return;

            context.read<TagCubit>().renameTag(widget.tagId, newName);
            // preserve behavior: reload notes after renaming
            context.read<NoteCubit>().loadNotes();
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
