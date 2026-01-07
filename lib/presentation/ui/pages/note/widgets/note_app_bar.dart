import 'package:flutter/material.dart';

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEdit;
  const NoteAppBar({Key? key, required this.isEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      title: Text(
        isEdit ? 'Chỉnh sửa ghi chú' : 'Ghi chú mới',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
