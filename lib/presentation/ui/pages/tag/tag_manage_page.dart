import 'package:flutter/material.dart';

import 'widgets/tag_manage_app_bar.dart';
import 'widgets/tag_manage_body.dart';

// Dialogs
import 'dialogs/create_tag_dialog.dart';

class TagManagementPage extends StatelessWidget {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TagManageAppBar(),
      body: const TagManageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTagDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showAddTagDialog(BuildContext context) async {
    await showDialog(context: context, builder: (_) => const CreateTagDialog());
  }
}
