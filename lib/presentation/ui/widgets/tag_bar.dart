import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/domain/entities/tag_entity.dart';
import 'package:notes/presentation/cubits/note/note_cubit.dart';

class TagBar extends StatelessWidget {
  final List<TagEntity> tags;
  final int? selectedTagId;

  const TagBar({
    super.key,
    required this.tags,
    required this.selectedTagId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          ChoiceChip(
            label: const Text('Tất cả'),
            selected: selectedTagId == null,
            onSelected: (_) {
              context.read<NoteCubit>().selectTag(null);
            },
          ),
          const SizedBox(width: 8),
          ...tags.map(
            (tag) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(tag.name),
                selected: selectedTagId == tag.id,
                onSelected: (_) {
                  context.read<NoteCubit>().selectTag(tag.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
