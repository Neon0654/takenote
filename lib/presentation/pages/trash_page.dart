import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/database/notes_database.dart';
import '../../data/models/note.dart';
import '../../utils/confirm_dialog.dart';
import '../../controllers/selection_controller.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<Note> trashNotes = [];
  bool isLoading = true;

  final SelectionController selectionController = SelectionController();

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  Future<void> _loadTrash() async {
    trashNotes = await NotesDatabase.instance.fetchTrashNotes();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ================= DELETE MULTI =================
  Future<void> _deleteSelectedForever() async {
    final ids = selectionController.selectedIds;
    if (ids.isEmpty) return;

    final ok = await showConfirmDialog(
      context: context,
      title: 'Xóa vĩnh viễn',
      content: 'Xóa ${ids.length} ghi chú vĩnh viễn?',
    );
    if (!ok) return;

    for (final id in ids) {
      await NotesDatabase.instance.deleteNotePermanently(id);
    }

    selectionController.clear();
    await _loadTrash();
  }

  // ================= DELETE SINGLE =================
  Future<void> _deleteOne(Note note) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Xóa vĩnh viễn',
      content: 'Xóa ghi chú này vĩnh viễn?',
    );
    if (!ok) return;

    await NotesDatabase.instance.deleteNotePermanently(note.id!);
    _loadTrash();
  }

  String _formatDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  Future<void> _restoreSelected() async {
    final ids = selectionController.selectedIds;
    if (ids.isEmpty) return;

    for (final id in ids) {
      await NotesDatabase.instance.restoreNote(id);
    }

    selectionController.clear();
    await _loadTrash();
  }
  
  Future<void> _restoreOne(Note note) async {
    await NotesDatabase.instance.restoreNote(note.id!);
    _loadTrash();
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
                  : 'Thùng rác',
            ),
            actions: selectionController.isSelectionMode
              ? [
                  IconButton(
                    tooltip: 'Khôi phục',
                    icon: const Icon(Icons.restore),
                    onPressed: _restoreSelected,
                  ),
                  IconButton(
                    tooltip: 'Chọn tất cả',
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      selectionController.selectAll(
                        trashNotes.map((e) => e.id!).toList(),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Xóa vĩnh viễn',
                    icon: const Icon(Icons.delete_forever),
                    onPressed: _deleteSelectedForever,
                  ),
                ]
              : null,

          ),

          // ================= BODY =================
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : trashNotes.isEmpty
                  ? const Center(child: Text('Thùng rác trống'))
                  : ListView.builder(
                      itemCount: trashNotes.length,
                      itemBuilder: (_, index) {
                        final note = trashNotes[index];
                        final isSelected =
                            selectionController.isSelected(note.id!);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          color:
                              isSelected ? Colors.red.shade50 : null,
                          child: ListTile(
                            onTap: selectionController.isSelectionMode
                                ? () => selectionController.toggle(note.id!)
                                : null,
                            onLongPress: () => selectionController
                                .startSelection(note.id!),

                            leading: selectionController.isSelectionMode
                                ? Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => selectionController
                                        .toggle(note.id!),
                                  )
                                : const Icon(Icons.delete_outline),

                            title: Text(
                              note.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '${_formatDate(note.createdAt)}\n${note.content}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            isThreeLine: true,

                            trailing: selectionController.isSelectionMode
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Khôi phục',
                                    icon: const Icon(Icons.restore, color: Colors.green),
                                    onPressed: () => _restoreOne(note),
                                  ),
                                  IconButton(
                                    tooltip: 'Xóa vĩnh viễn',
                                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                                    onPressed: () => _deleteOne(note),
                                  ),
                                ],
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
