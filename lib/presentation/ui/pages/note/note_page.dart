import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/cubits/note/note_state.dart';

import '../../../../domain/entities/note_entity.dart';
import '../../../../presentation/cubits/note/note_cubit.dart';
import '../../../ui/widgets/tag_selector_dialog.dart';
import '../../../../data/viewmodel/note_view_model.dart';
import 'widgets/note_app_bar.dart';
import 'widgets/note_body.dart';

class NotePage extends StatefulWidget {
  final NoteEntity? note;
  final int? folderId;

  
  
  
  
  const NotePage({super.key, this.note, this.folderId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get isEdit => widget.note != null;
  bool _showMetaDetail = false;

  
  
  
  bool _controllersInitedFromVm = false;

  @override
  void initState() {
    super.initState();
    
    
    
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _initControllersFromVm(NoteViewModel vm) {
    if (_controllersInitedFromVm) return;

    
    
    _titleController.text = vm.note.title;
    _contentController.text = vm.note.content;
    _controllersInitedFromVm = true;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final cubit = context.read<NoteCubit>();
    final state = cubit.state;

    if (isEdit && widget.note?.id != null) {
      
      NoteEntity current = widget.note!;

      if (state is NoteLoaded) {
        final vm = state.notes.firstWhere(
          (e) => e.note.id == widget.note!.id,
          orElse: () => NoteViewModel(
            note: widget.note!,
            attachmentCount: 0,
            attachments: const [],
            reminders: const [],
          ),
        );
        current = vm.note;
      }

      await cubit.updateNote(current.copyWith(title: title, content: content));
    } else {
      await cubit.addNote(title, content, folderId: widget.folderId);
    }

    if (mounted) Navigator.pop(context);
  }

  void _toggleMetaDetail() {
    setState(() => _showMetaDetail = !_showMetaDetail);
  }

  Future<void> _onAddTag(int noteId) async {
    await showDialog(
      context: context,
      builder: (_) => TagSelectorDialog(noteId: noteId),
    );

    await context.read<NoteCubit>().loadNotes();
  }

  
  
  
  
  Future<void> _openReminderDialog(int noteId) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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

    if (remindAt.isBefore(DateTime.now())) return;

    await context.read<NoteCubit>().addReminderToNote(
      noteId: noteId,
      remindAt: remindAt,
    );
  }

  
  Future<void> _pickAttachment(int noteId) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = result.files.single;
    if (file.path == null) return;

    await context.read<NoteCubit>().addAttachmentToNote(
      noteId: noteId,
      filePath: file.path!,
      fileName: p.basename(file.path!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _save();
        return true;
      },
      child: Scaffold(
        appBar: NoteAppBar(isEdit: isEdit),

        body: BlocBuilder<NoteCubit, NoteState>(
          
          
          bloc: context.read<NoteCubit>(),
          builder: (context, state) {
            
            
            if (widget.note == null) {
              final vm = NoteViewModel(
                note: NoteEntity(
                  id: null,
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: DateTime.now(),
                ),
                attachmentCount: 0,
                attachments: const [],
                reminders: const [],
              );

              _initControllersFromVm(vm);
              return NoteBody(
                vm: vm,
                titleController: _titleController,
                contentController: _contentController,
                showMetaDetail: _showMetaDetail,
                toggleMetaDetail: _toggleMetaDetail,
                onAddTag: (id) => _onAddTag(id),
                onPickAttachment: (id) => _pickAttachment(id),
                onAddReminder: (id) => _openReminderDialog(id),
              );
            }

            
            if (state is! NoteLoaded) {
              return const SizedBox();
            }

            final vm = state.notes.firstWhere(
              (e) => e.note.id == widget.note!.id,
              orElse: () => NoteViewModel(
                note: widget.note!,
                attachmentCount: 0,
                attachments: const [],
                reminders: const [],
              ),
            );

            _initControllersFromVm(vm);
            return NoteBody(
              vm: vm,
              titleController: _titleController,
              contentController: _contentController,
              showMetaDetail: _showMetaDetail,
              toggleMetaDetail: _toggleMetaDetail,
              onAddTag: (id) => _onAddTag(id),
              onPickAttachment: (id) => _pickAttachment(id),
              onAddReminder: (id) => _openReminderDialog(id),
            );
          },
        ),
      ),
    );
  }
}
