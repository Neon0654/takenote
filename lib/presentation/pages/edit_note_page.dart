import 'package:flutter/material.dart';
import '../../data/models/note.dart';
import '../../controllers/edit_note_controller.dart';
import '../widgets/tag_selector_dialog.dart';
import '../../data/database/notes_database.dart';
import '../../data/models/tag.dart';

class EditNotePage extends StatefulWidget {
  final Note? note; // null = thêm mới
  final Function(String title, String content) onSave;

  const EditNotePage({
    super.key,
    this.note,
    required this.onSave,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  EditNoteController? controller;

  bool get isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.note?.title ?? '');
    contentController =
        TextEditingController(text: widget.note?.content ?? '');

    // ✅ chỉ tạo controller khi EDIT
    if (isEdit) {
      controller = EditNoteController(
        note: widget.note!,
        onSave: widget.onSave,
      );

      titleController.addListener(_onChanged);
      contentController.addListener(_onChanged);
    }
  }

  void _onChanged() {
    controller?.onTextChanged(
      title: titleController.text.trim(),
      content: contentController.text.trim(),
    );
  }

  Future<bool> _onBack() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    // 🆕 ADD → chỉ save khi back
    if (!isEdit && (title.isNotEmpty || content.isNotEmpty)) {
      widget.onSave(title, content);
    }

    // ✨ EDIT → force save
    if (isEdit) {
      controller?.forceSave(title, content);
    }

    return true;
  }

  @override
  void dispose() {
    controller?.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Chỉnh sửa ghi chú' : 'Thêm ghi chú'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== TITLE =====
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  border: InputBorder.none,
                ),
              ),

              // ===== TAG HIỂN THỊ (CHỈ KHI ĐÃ LƯU) =====
              if (isEdit)
                FutureBuilder<List<Tag>>(
                  future: NotesDatabase.instance
                      .getTagsOfNote(widget.note!.id!),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }

                    final tags = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Wrap(
                        spacing: 6,
                        children: tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag.name),
                                onDeleted: () async {
                                  await NotesDatabase.instance
                                      .removeTagFromNote(
                                    widget.note!.id!,
                                    tag.id!,
                                  );
                                  setState(() {});
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),

              const Divider(),

              // ===== + THÊM TAG (KHÔNG BẮT BUỘC LƯU NỮA) =====
              GestureDetector(
  onTap: () async {
    if (!isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu ghi chú trước khi thêm tag'),
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => TagSelectorDialog(
        noteId: widget.note!.id!,
      ),
    );

    setState(() {});
  },
  child: const Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Text(
      '+ Thêm tag',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),


              // ===== CONTENT =====
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Nội dung ghi chú...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
