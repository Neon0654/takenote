import 'package:flutter/material.dart';
import '../../data/database/notes_database.dart';
import '../../data/models/tag.dart';
import '../../utils/confirm_dialog.dart';

class TagManagementPage extends StatefulWidget {
  const TagManagementPage({super.key});

  @override
  State<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends State<TagManagementPage> {
  List<Tag> tags = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    tags = await NotesDatabase.instance.fetchTags();
    setState(() {});
  }

  Future<void> _addTag(String name) async {
    if (name.isEmpty) return;
    await NotesDatabase.instance.createTag(name);
    _controller.clear();
    _load();
  }

  Future<void> _deleteTag(Tag tag) async {
    final db = NotesDatabase.instance;
    final database = await db.database;

    // Xóa liên kết trước
    await database.delete(
      'note_tags',
      where: 'tagId = ?',
      whereArgs: [tag.id],
    );

    // Xóa tag
    await database.delete(
      'tags',
      where: 'id = ?',
      whereArgs: [tag.id],
    );

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý nhãn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Tên nhãn mới',
                prefixIcon: Icon(Icons.add),
              ),
              onSubmitted: _addTag,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: tags.length,
                itemBuilder: (_, i) {
                  final tag = tags[i];
                  return ListTile(
                    leading: const Icon(Icons.label_outline),
                    title: Text(tag.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final ok = await showConfirmDialog(
                          context: context,
                          content: 'Xóa nhãn "${tag.name}"?',
                        );

                        if (ok) {
                          _deleteTag(tag);
                        }
                      },

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
