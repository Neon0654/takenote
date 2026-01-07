import 'package:flutter/material.dart';

import 'widgets/select_notes_app_bar.dart';
import 'widgets/select_notes_body.dart';

class SelectNotesPage extends StatelessWidget {
  final int? targetFolderId;

  const SelectNotesPage({super.key, this.targetFolderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SelectNotesAppBar(targetFolderId: targetFolderId),
      body: const SelectNotesBody(),
    );
  }
}
