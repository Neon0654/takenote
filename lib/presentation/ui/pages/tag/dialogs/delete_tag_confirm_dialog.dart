import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/tag/tag_cubit.dart';
import '../../../../cubits/note/note_cubit.dart';


class DeleteTagConfirmDialog extends StatelessWidget {
  final int tagId;

  const DeleteTagConfirmDialog({Key? key, required this.tagId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xóa nhãn'),
      content: const Text(
        'Nhãn này sẽ bị gỡ khỏi tất cả ghi chú. Bạn có chắc không?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            context.read<TagCubit>().deleteTag(tagId);
            context.read<NoteCubit>().loadNotes();
            Navigator.pop(context);
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
