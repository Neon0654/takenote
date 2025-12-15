import 'package:flutter/material.dart';
import '../../data/database/notes_database.dart';
import '../../data/models/tag.dart';

class TagSelectorDialog extends StatefulWidget {
  final int noteId;

  const TagSelectorDialog({super.key, required this.noteId});

  @override
  State<TagSelectorDialog> createState() => _TagSelectorDialogState();
}

class _TagSelectorDialogState extends State<TagSelectorDialog> {
  List<Tag> allTags = [];
  List<Tag> noteTags = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    allTags = await NotesDatabase.instance.fetchTags();
    noteTags =
        await NotesDatabase.instance.getTagsOfNote(widget.noteId);
    setState(() {});
  }

  bool _isSelected(Tag tag) =>
      noteTags.any((t) => t.id == tag.id);

  Future<void> _toggle(Tag tag) async {
    if (_isSelected(tag)) {
      await NotesDatabase.instance.removeTagFromNote(
        widget.noteId,
        tag.id!,
      );
    } else {
      await NotesDatabase.instance.addTagToNote(
        widget.noteId,
        tag.id!,
      );
    }
    _load();
  }

  Future<void> _createTag(String name) async {
    if (name.isEmpty) return;

    await NotesDatabase.instance.createTag(name);
    final tags = await NotesDatabase.instance.fetchTags();
    final tag = tags.firstWhere((t) => t.name == name);

    await NotesDatabase.instance.addTagToNote(
      widget.noteId,
      tag.id!,
    );

    _controller.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gắn nhãn'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration:
                const InputDecoration(hintText: 'Nhãn mới'),
            onSubmitted: _createTag,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              children: allTags
                  .map(
                    (tag) => CheckboxListTile(
                      value: _isSelected(tag),
                      title: Text(tag.name),
                      onChanged: (_) => _toggle(tag),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final name = _controller.text.trim();

            // 🔥 NẾU CÓ NHẬP TAG → LƯU TAG
            if (name.isNotEmpty) {
              await NotesDatabase.instance.createTag(name);
            }

            Navigator.pop(context, true);
          },
          child: const Text('Xong'),
        ),


      ],
    );
  }
}
