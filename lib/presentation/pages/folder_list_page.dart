import 'package:flutter/material.dart';

import '../../data/database/notes_database.dart';
import '../../data/models/folder.dart';
import '../../utils/confirm_dialog.dart';
import '../../controllers/selection_controller.dart';

import 'folder_notes_page.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({super.key});

  @override
  State<FolderListPage> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> {
  List<Folder> folders = [];

  /// folderId -> số note
  Map<int, int> _folderNoteCount = {};

  final SelectionController selectionController = SelectionController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await NotesDatabase.instance.fetchFolders();
    final counts = await NotesDatabase.instance.countNotesByFolder();

    if (!mounted) return;

    setState(() {
      folders = list;
      _folderNoteCount = counts;
    });
  }

  // ================= DELETE MULTI =================
  Future<void> _deleteSelected() async {
    final ids = selectionController.selectedIds;
    if (ids.isEmpty) return;

    final ok = await showConfirmDialog(
      context: context,
      content: 'Xóa ${ids.length} thư mục đã chọn?',
    );
    if (!ok) return;

    for (final id in ids) {
      await NotesDatabase.instance.deleteFolder(id);
    }

    selectionController.clear();
    await _load();
  }

  // ================= DELETE SINGLE =================
  Future<void> _deleteOne(Folder folder) async {
    final ok = await showConfirmDialog(
      context: context,
      content: 'Xóa thư mục "${folder.name}"?',
    );
    if (!ok) return;

    await NotesDatabase.instance.deleteFolder(folder.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: selectionController,
      builder: (_, __) {
        return Scaffold(
          // ================= APP BAR =================
          appBar: AppBar(
            leading: selectionController.isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: selectionController.clear,
                  )
                : null,
            title: Text(
              selectionController.isSelectionMode
                  ? '${selectionController.selectedIds.length} đã chọn'
                  : 'Thư mục',
            ),
            actions: selectionController.isSelectionMode
                ? [
                    IconButton(
                      tooltip: 'Chọn tất cả',
                      icon: const Icon(Icons.select_all),
                      onPressed: () {
                        selectionController.selectAll(
                          folders.map((e) => e.id!).toList(),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Xóa',
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteSelected,
                    ),
                  ]
                : null,
          ),

          // ================= BODY =================
          body: folders.isEmpty
              ? const Center(child: Text('Chưa có thư mục'))
              : ListView.builder(
                  itemCount: folders.length,
                  itemBuilder: (_, i) {
                    final f = folders[i];
                    final count = _folderNoteCount[f.id] ?? 0;
                    final isSelected =
                        selectionController.isSelected(f.id!);

                    return Card(
                      color:
                          isSelected ? Colors.blue.shade50 : null,
                      child: ListTile(
                        onTap: selectionController.isSelectionMode
                            ? () =>
                                selectionController.toggle(f.id!)
                            : () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FolderNotesPage(folder: f),
                                  ),
                                );
                                _load();
                              },
                        onLongPress: () =>
                            selectionController.startSelection(f.id!),

                        leading: selectionController.isSelectionMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    selectionController.toggle(f.id!),
                              )
                            : Icon(
                                Icons.folder,
                                color: Color(f.color),
                              ),

                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                f.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '($count)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        trailing: selectionController.isSelectionMode
                            ? null
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteOne(f),
                              ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
