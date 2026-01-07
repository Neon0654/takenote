import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/folder/folder_cubit.dart';

/// Confirmation dialog for deleting a folder. UI-only.
class DeleteFolderConfirmDialog extends StatelessWidget {
  final int folderId;
  final String folderName;

  const DeleteFolderConfirmDialog({Key? key, required this.folderId, required this.folderName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xóa thư mục'),
      content: Text('Xóa "$folderName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            context.read<FolderCubit>().deleteFolder(folderId);
            Navigator.pop(context);
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
