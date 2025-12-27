import 'package:flutter/material.dart';

import '../../data/models/folder.dart';
import '../../controllers/notes_controller.dart';
import '../../utils/confirm_dialog.dart';

import 'create_folder_dialog.dart';
import 'search_page.dart';
import 'trash_page.dart';
import '../../data/database/notes_database.dart';


class FolderNotesPage extends StatefulWidget {
  final Folder folder;

  const FolderNotesPage({
    super.key,
    required this.folder,
  });

  @override
  State<FolderNotesPage> createState() => _FolderNotesPageState();
}

class _FolderNotesPageState extends State<FolderNotesPage> {
  late Folder _folder;

  @override
  void initState() {
    super.initState();
    _folder = widget.folder;
  }

  // ================= MENU =================
  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'edit':
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => CreateFolderDialog(folder: _folder),
        );

        if (ok == true && mounted) {
          setState(() {}); // reload title + color
        }
        break;

      case 'search':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SearchPage(),
          ),
        );
        break;

      case 'trash':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TrashPage(),
          ),
        );
        break;

      case 'delete':
        final ok = await showConfirmDialog(
          context: context,
          content: 'Xóa thư mục "${_folder.name}"?',
        );
        if (!ok) return;

        await NotesDatabase.instance.deleteFolder(_folder.id!);
        if (mounted) Navigator.pop(context);
        break;
    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: NotesController(
            folderId: widget.folder.id!,
            folder: widget.folder, // 🔥 truyền folder
            isFolderMode: true,
          ),
        ),
      );
    }


}
