import 'package:flutter/material.dart';

import '../../data/database/notes_database.dart';
import '../../data/models/folder.dart';

class CreateFolderDialog extends StatefulWidget {
  final Folder? folder; // null = tạo | != null = chỉnh sửa

  const CreateFolderDialog({super.key, this.folder});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _nameController = TextEditingController();

  int _selectedColor = Colors.blue.value;
  String? _errorText;

  final List<Color> _colors = const [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();

    // ===== EDIT MODE =====
    if (widget.folder != null) {
      _nameController.text = widget.folder!.name;
      _selectedColor = widget.folder!.color;
    }
  }

  Future<void> _saveFolder() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorText = 'Phải nhập tên thư mục';
      });
      return;
    }

    // ===== UPDATE =====
    if (widget.folder != null) {
      final db = await NotesDatabase.instance.database;

      await db.update(
        'folders',
        {
          'name': name,
          'color': _selectedColor,
        },
        where: 'id = ?',
        whereArgs: [widget.folder!.id],
      );
    }
    // ===== CREATE =====
    else {
      await NotesDatabase.instance.createFolder(
        Folder(
          name: name,
          color: _selectedColor,
          createdAt: DateTime.now(),
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.folder != null ? 'Chỉnh sửa thư mục' : 'Thêm thư mục',
      ),
      content: SizedBox(
        width: 320,
        height: 260,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== NAME =====
              TextField(
                controller: _nameController,
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: 'Tên thư mục',
                  errorText: _errorText,
                  counterText: '',
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() => _errorText = null);
                  }
                },
              ),

              const SizedBox(height: 16),

              const Text(
                'Màu thư mục',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color.value;
                      });
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _saveFolder,
          child: Text(widget.folder != null ? 'Lưu' : 'Thêm'),
        ),
      ],
    );
  }
}
