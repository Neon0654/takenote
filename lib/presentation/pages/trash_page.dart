import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/database/notes_database.dart';
import '../../data/models/note.dart';
import '../../utils/confirm_dialog.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<Note> trashNotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  Future<void> _loadTrash() async {
    trashNotes = await NotesDatabase.instance.fetchTrashNotes();
    setState(() => isLoading = false);
  }

  Future<void> _restore(Note note) async {
    await NotesDatabase.instance.restoreNote(note.id!);
    _loadTrash();
  }

  Future<void> _deleteForever(Note note) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thùng rác'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : trashNotes.isEmpty
              ? const Center(child: Text('Thùng rác trống'))
              : ListView.builder(
                  itemCount: trashNotes.length,
                  itemBuilder: (_, index) {
                    final note = trashNotes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 🔄 RESTORE
                            IconButton(
                              tooltip: 'Khôi phục',
                              icon: const Icon(Icons.restore,
                                  color: Colors.green),
                              onPressed: () => _restore(note),
                            ),
                            // ❌ DELETE FOREVER
                            IconButton(
                              tooltip: 'Xóa vĩnh viễn',
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              onPressed: () => _deleteForever(note),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
