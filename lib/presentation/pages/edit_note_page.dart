import 'package:flutter/material.dart';

import '../../data/models/note.dart';
import '../../data/models/tag.dart';
import '../../data/models/reminder.dart';
import '../../controllers/edit_note_controller.dart';
import '../../data/database/notes_database.dart';
import '../widgets/tag_selector_dialog.dart';
import '../../utils/confirm_dialog.dart';
import '../../utils/confirm_dialog.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/attachment.dart';
import 'package:open_filex/open_filex.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';





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
  Reminder? reminder;

  bool get isEdit => widget.note != null;

  List<Attachment> attachments = [];

  List<Reminder> reminders = [];


  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.note?.title ?? '');
    contentController =
        TextEditingController(text: widget.note?.content ?? '');

    // AUTO SAVE khi edit
    if (isEdit) {
      controller = EditNoteController(
        note: widget.note!,
        onSave: widget.onSave,
      );

      titleController.addListener(_onChanged);
      contentController.addListener(_onChanged);

      // LOAD REMINDER
      NotesDatabase.instance
          .getRemindersOfNote(widget.note!.id!)
          .then((list) {
        if (mounted) setState(() => reminders = list);
      });


      NotesDatabase.instance
          .getAttachmentsOfNote(widget.note!.id!)
          .then((list) {
        if (mounted) {
          setState(() => attachments = list);
        }
      });

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

    // ADD
    if (!isEdit && (title.isNotEmpty || content.isNotEmpty)) {
      widget.onSave(title, content);
    }

    // EDIT
    if (isEdit) {
      controller?.forceSave(title, content);
    }

    return true;
  }

  

  Future<void> _pickFile() async {
    if (!isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu ghi chú trước khi đính kèm')),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.single;
    final tempPath = file.path!;
    final appDir = await getApplicationDocumentsDirectory();

    final newPath = '${appDir.path}/${file.name}';
    await File(tempPath).copy(newPath);

    final attachment = Attachment(
      noteId: widget.note!.id!,
      fileName: file.name,
      filePath: newPath,
    );

    await NotesDatabase.instance.addAttachment(attachment);

    final list = await NotesDatabase.instance
        .getAttachmentsOfNote(widget.note!.id!);

    setState(() => attachments = list);
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

              // ===== TAG HIỂN THỊ =====
              if (isEdit)
                FutureBuilder<List<Tag>>(
                  future: NotesDatabase.instance
                      .getTagsOfNote(widget.note!.id!),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }

                    final tags = snapshot.data!;
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6),
                      child: Wrap(
                        spacing: 6,
                        children: tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag.name),
                                onDeleted: () async {
                                  final ok = await showConfirmDialog(
                                    context: context,
                                    content: 'Gỡ nhãn "${tag.name}" khỏi ghi chú?',
                                  );

                                  if (!ok) return;

                                  await NotesDatabase.instance.removeTagFromNote(
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

              // ===== ATTACHMENT =====
              if (isEdit)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.attach_file),
                      title: const Text('Đính kèm tệp'),
                      onTap: _pickFile,
                    ),

                    if (attachments.isNotEmpty)
                      Column(
                        children: attachments.map((a) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.insert_drive_file),
                            title: Text(
                              a.fileName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              final result = await OpenFilex.open(a.filePath);
                              if (result.type != ResultType.done) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Không thể mở tệp')),
                                );
                              }
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final ok = await showConfirmDialog(
                                  context: context,
                                  content: 'Xóa tệp "${a.fileName}"?',
                                );
                                if (!ok) return;

                                await File(a.filePath).delete();
                                await NotesDatabase.instance
                                    .deleteAttachment(a.id!);

                                final list =
                                    await NotesDatabase.instance.getAttachmentsOfNote(
                                  widget.note!.id!,
                                );
                                setState(() => attachments = list);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),


              // ===== + THÊM TAG =====
              GestureDetector(
                onTap: () async {
                  if (!isEdit) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Lưu ghi chú trước khi thêm tag'),
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

              // ===== REMINDER =====
              // CHỈ PHẦN REMINDER – DÁN THAY THẾ PHẦN CŨ

              if (isEdit)
                FutureBuilder<List<Reminder>>(
                  future: NotesDatabase.instance.getRemindersOfNote(widget.note!.id!),
                  builder: (context, snapshot) {
                    final reminders = snapshot.data ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.alarm),
                          title: const Text('Thêm nhắc nhở'),
                          onTap: () async {
                            final now = DateTime.now();

                            final date = await showDatePicker(
                              context: context,
                              firstDate: now,
                              lastDate: DateTime(now.year + 5),
                              initialDate: now,
                            );
                            if (date == null) return;

                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time == null) return;

                            final remindAt = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );

                            final notificationId =
                                DateTime.now().millisecondsSinceEpoch ~/ 1000;

                            await NotesDatabase.instance.createReminder(
                              Reminder(
                                noteId: widget.note!.id!,
                                remindAt: remindAt,
                                notificationId: notificationId,
                              ),
                            );

                            await NotificationService.schedule(
                              id: notificationId,
                              title: widget.note!.title,
                              body: widget.note!.content,
                              time: remindAt,
                            );

                            setState(() {}); // 🔥 BẮT BUỘC
                          },
                        ),

                        // ===== DANH SÁCH REMINDER =====
                        ...reminders.map(
                          (r) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.alarm, color: Colors.red),
                            title: Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(r.remindAt),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final ok = await showConfirmDialog(
                                  context: context,
                                  content: 'Xóa nhắc nhở này?',
                                );
                                if (!ok) return;

                                await NotificationService.cancel(r.notificationId);
                                await NotesDatabase.instance.deleteReminder(r.id!);

                                setState(() {}); // 🔥 BẮT BUỘC
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
