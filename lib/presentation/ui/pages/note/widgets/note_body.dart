import 'package:flutter/material.dart';
import 'package:notes/data/viewmodel/note_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/presentation/cubits/note/note_cubit.dart';

class NoteBody extends StatelessWidget {
  final NoteViewModel vm;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool showMetaDetail;
  final VoidCallback toggleMetaDetail;
  final ValueChanged<int> onAddTag;
  final ValueChanged<int> onPickAttachment;
  final ValueChanged<int> onAddReminder;

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
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Tiêu đề',
                  hintStyle: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.outlineVariant,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _MetaActions(
                      noteId: note.id,
                      showMetaDetail: showMetaDetail,
                      onAddTag: onAddTag,
                      onPickAttachment: onPickAttachment,
                      onAddReminder: onAddReminder,
                      toggleMetaDetail: toggleMetaDetail,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: showMetaDetail
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: _MetaDetail(vm: vm),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: contentController,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  hintText: 'Nội dung ghi chú...',
                  hintStyle: TextStyle(color: theme.colorScheme.outlineVariant),
                  border: InputBorder.none,
                ),
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _metaButton(context, Icons.label_outline, 'Tag', () {
                    if (noteId != null) onAddTag(noteId!);
                  }),
                  _metaButton(context, Icons.attach_file, 'Đính kèm', () {
                    if (noteId != null) onPickAttachment(noteId!);
                  }),
                  _metaButton(context, Icons.alarm, 'Nhắc nhở', () {
                    if (noteId != null) onAddReminder(noteId!);
                  }),
                ],
              ),
            ),
          ),
          VerticalDivider(
            indent: 8,
            endIndent: 8,
            color: theme.colorScheme.outlineVariant,
          ),
          IconButton.filledTonal(
            onPressed: toggleMetaDetail,
            icon: Icon(
              showMetaDetail
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton.tonalIcon(
        onPressed: noteId == null ? null : onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _MetaDetail extends StatelessWidget {
  final NoteViewModel vm;
  const _MetaDetail({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final note = vm.note;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (note.tags.isNotEmpty) ...[
          Text(
            'Nhãn đã thêm',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            children: note.tags
                .map(
                  (t) => Chip(
                    label: Text('#${t.name}'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.colorScheme.surface,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (vm.attachments.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Tệp đính kèm',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: vm.attachments.map((a) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(Icons.attach_file, size: 18),
                  title: Text(
                    a.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                    color: theme.colorScheme.error,
                    onPressed: () {
                      context.read<NoteCubit>().deleteAttachment(a.id!);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        if (vm.reminders.isNotEmpty) ...[
          Text(
            'Nhắc nhở',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...vm.reminders.map(
            (r) => Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  Icons.alarm,
                  size: 18,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  '${r.remindAt.day}/${r.remindAt.month}/${r.remindAt.year} '
                  '${r.remindAt.hour}:${r.remindAt.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                  color: theme.colorScheme.error,
                  onPressed: () {
                    context.read<NoteCubit>().deleteReminder(r.id!);
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
