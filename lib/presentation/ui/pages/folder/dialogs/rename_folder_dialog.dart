import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/folder/folder_cubit.dart';

/// Dialog to rename a folder. UI-only: takes current name, lets user input new name.
class RenameFolderDialog extends StatefulWidget {
  final int folderId;
  final String initialName;

  const RenameFolderDialog({Key? key, required this.folderId, required this.initialName}) : super(key: key);

  @override
  State<RenameFolderDialog> createState() => _RenameFolderDialogState();
}

class _RenameFolderDialogState extends State<RenameFolderDialog> {
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
      title: const Text('Đổi tên thư mục'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Tên thư mục'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<FolderCubit>().renameFolder(
                  widget.folderId,
                  _controller.text,
                );
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
