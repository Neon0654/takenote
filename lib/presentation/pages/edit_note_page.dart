import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/note.dart';

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

  Timer? _debounce;

  bool get isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');

    // ✅ CHỈ autosave khi EDIT
    if (isEdit) {
      titleController.addListener(_autoSave);
      contentController.addListener(_autoSave);
    }
  }

  void _autoSave() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      final title = titleController.text.trim();
      final content = contentController.text.trim();

      if (title.isEmpty && content.isEmpty) return;

      widget.onSave(title, content);
    });
  }

  Future<bool> _onBack() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    // 🆕 ADD → chỉ lưu khi back
    if (!isEdit && (title.isNotEmpty || content.isNotEmpty)) {
      widget.onSave(title, content);
    }

    return true;
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
            children: [
              // TIÊU ĐỀ
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

              const Divider(),

              // NỘI DUNG
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Nội dung ghi chú...',
                    hintStyle: TextStyle(color: Colors.grey),
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
