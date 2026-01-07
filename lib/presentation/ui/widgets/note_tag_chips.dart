import 'package:flutter/material.dart';
import '../../../domain/entities/tag_entity.dart';

class NoteTagChips extends StatelessWidget {
  final List<TagEntity> tags;
  final int maxChips;

  const NoteTagChips({
    super.key,
    required this.tags,
    this.maxChips = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox();

    final visibleTags = tags.take(maxChips).toList();
    final remaining = tags.length - visibleTags.length;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: -8,
        children: [
          ...visibleTags.map(
            (tag) => Chip(
              label: Text(
                tag.name,
                style: const TextStyle(fontSize: 11),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          if (remaining > 0)
            Chip(
              label: Text(
                '+$remaining',
                style: const TextStyle(fontSize: 11),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
