import 'package:flutter/material.dart';

/// Simple AppBar for NotePage.
class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEdit;
  const NoteAppBar({Key? key, required this.isEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(isEdit ? 'Chỉnh sửa ghi chú' : 'Thêm ghi chú'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
