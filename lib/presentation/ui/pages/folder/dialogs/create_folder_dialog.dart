import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/folder/folder_cubit.dart';
import '../../../../cubits/note/note_cubit.dart';

/// Dialog to create a folder. UI-only: reads user input and calls cubit methods.
class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({Key? key}) : super(key: key);

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _controller = TextEditingController();
  int _color = Colors.blue.value;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm thư mục'),
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
            context.read<FolderCubit>().createFolder(
                  _controller.text,
                  _color,
                );
            Navigator.pop(context);

            // optional: reset note view (preserve existing behavior)
            context.read<NoteCubit>().showAll();
          },
          child: const Text('Tạo'),
        ),
      ],
    );
  }
}
