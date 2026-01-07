import 'package:flutter/material.dart';
import '../../../domain/entities/tag_entity.dart';

class NoteMetaRow extends StatelessWidget {
  final List<TagEntity> tags;
  final bool hasReminder;
  final int attachmentCount;

  final VoidCallback? onShowAllTags;
  final VoidCallback? onTapReminder;
  final VoidCallback? onTapAttachment;

  const NoteMetaRow({
    super.key,
    required this.tags,
    required this.hasReminder,
    required this.attachmentCount,
    this.onShowAllTags,
    this.onTapReminder,
    this.onTapAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // TAG
        _buildTagPart(),

        // REMINDER
        if (hasReminder)
          InkWell(
            onTap: onTapReminder,
            child: const Icon(Icons.alarm, size: 18),
          ),

        // ATTACHMENT
        if (attachmentCount > 0)
          InkWell(
            onTap: onTapAttachment,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file, size: 18),
                const SizedBox(width: 2),
                Text('$attachmentCount'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTagPart() {
    // 0 tag
    if (tags.isEmpty) {
      return InkWell(
        onTap: onShowAllTags,
        child: const Text(
          '+ Thêm tag',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }

    // 1 tag
    if (tags.length == 1) {
      return _tagChip(tags.first.name);
    }

    // >=2 tag
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tagChip(tags.first.name),
        const SizedBox(width: 4),
        InkWell(
          onTap: onShowAllTags,
          child: Text(
            '+${tags.length - 1}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('#$name', style: const TextStyle(fontSize: 13)),
    );
  }
}

