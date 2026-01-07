import 'package:flutter/material.dart';

import 'widgets/folder_list_app_bar.dart';
import 'widgets/folder_list_body.dart';

import 'dialogs/create_folder_dialog.dart' as dialogs;

class FolderListPage extends StatelessWidget {
  const FolderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FolderListAppBar(),
      body: const FolderListBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const dialogs.CreateFolderDialog(),
    );
  }
}
