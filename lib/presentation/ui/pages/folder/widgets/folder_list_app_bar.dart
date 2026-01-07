import 'package:flutter/material.dart';

class FolderListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FolderListAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Thư mục'));
  }
}
