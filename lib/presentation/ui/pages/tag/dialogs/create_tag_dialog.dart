import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/tag/tag_cubit.dart';


class CreateTagDialog extends StatefulWidget {
  const CreateTagDialog({Key? key}) : super(key: key);

  @override
  State<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm nhãn'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Tên nhãn'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TagCubit>().createTag(_controller.text);
            Navigator.pop(context);
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
