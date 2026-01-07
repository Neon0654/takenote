import 'package:flutter/material.dart';
import 'package:notes/data/viewmodel/note_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/presentation/cubits/note/note_cubit.dart';

/// Note editor content separated into a dumb widget.
/// Receives controllers and callbacks from the parent stateful page.
class NoteBody extends StatelessWidget {
  final NoteViewModel vm;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool showMetaDetail;
  final VoidCallback toggleMetaDetail;
  final ValueChanged<int> onAddTag; // noteId
  final ValueChanged<int> onPickAttachment; // noteId
  final ValueChanged<int> onAddReminder; // noteId

  const NoteBody({
    Key? key,
    required this.vm,
    required this.titleController,
    required this.contentController,
    required this.showMetaDetail,
    required this.toggleMetaDetail,
    required this.onAddTag,
    required this.onPickAttachment,
    required this.onAddReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final note = vm.note;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Tiêu đề',
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          if (note.tags.isNotEmpty)
            Wrap(
              spacing: 6,
              children: note.tags.map((t) => Chip(label: Text('#${t.name}'))).toList(),
            ),

          const Divider(),

          _MetaActions(
            noteId: note.id,
            showMetaDetail: showMetaDetail,
            onAddTag: onAddTag,
            onPickAttachment: onPickAttachment,
            onAddReminder: onAddReminder,
            toggleMetaDetail: toggleMetaDetail,
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _MetaDetail(vm: vm),
            crossFadeState: showMetaDetail ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),

          const Divider(),

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
    );
  }
}

class _MetaActions extends StatelessWidget {
  final int? noteId;
  final bool showMetaDetail;
  final ValueChanged<int> onAddTag;
  final ValueChanged<int> onPickAttachment;
  final ValueChanged<int> onAddReminder;
  final VoidCallback toggleMetaDetail;

  const _MetaActions({
    Key? key,
    required this.noteId,
    required this.showMetaDetail,
    required this.onAddTag,
    required this.onPickAttachment,
    required this.onAddReminder,
    required this.toggleMetaDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _metaButton(Icons.label_outline, 'Thêm tag', () {
          if (noteId == null) return;
          onAddTag(noteId!);
        }),
        _metaButton(Icons.attach_file, 'Đính kèm', () {
          if (noteId == null) return;
          onPickAttachment(noteId!);
        }),
        _metaButton(Icons.alarm, 'Nhắc nhở', () {
          if (noteId == null) return;
          onAddReminder(noteId!);
        }),
        IconButton(
          icon: Icon(showMetaDetail ? Icons.expand_less : Icons.expand_more),
          onPressed: toggleMetaDetail,
        ),
      ],
    );
  }
}

class _MetaDetail extends StatelessWidget {
  final NoteViewModel vm;
  const _MetaDetail({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final note = vm.note;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TAGS
        if (note.tags.isNotEmpty) ...[
          const Text('Tag', style: TextStyle(fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 6,
            children: note.tags.map((t) => Chip(label: Text('#${t.name}'))).toList(),
          ),
        ],

        // REMINDERS
        ...vm.reminders.map(
          (r) => ListTile(
            dense: true,
            leading: const Icon(Icons.alarm),
            title: Text(
              '${r.remindAt.day}/${r.remindAt.month}/${r.remindAt.year} '
              '${r.remindAt.hour}:${r.remindAt.minute.toString().padLeft(2, '0')}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              tooltip: 'Xoá nhắc nhở',
              onPressed: () {
                context.read<NoteCubit>().deleteReminder(r.id!);
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget _metaButton(IconData icon, String label, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(right: 16),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 4), Text(label)],
      ),
    ),
  );
}
