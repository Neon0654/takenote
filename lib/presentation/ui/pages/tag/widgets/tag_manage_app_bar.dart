import 'package:flutter/material.dart';

class TagManageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TagManageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Quản lý nhãn'));
}
