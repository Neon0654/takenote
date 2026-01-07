import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/domain/entities/note_entity.dart';
import 'package:notes/presentation/cubits/note/note_cubit.dart';
import 'note_tag_chips.dart';

class NoteItem extends StatelessWidget {
  final NoteEntity note;
  final bool selected;
  final int attachmentCount;
  final bool hasReminder;

  const NoteItem({
    super.key,
    required this.note,
    this.selected = false,
    required this.attachmentCount,
    required this.hasReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? Colors.blue
              : (note.isPinned ? Colors.orange : Colors.grey.shade300),
          width: selected ? 2 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  note.title.isEmpty ? '(Không tiêu đề)' : note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),

              
              GestureDetector(
                onTap: () {
                  context.read<NoteCubit>().togglePin(note);
                },
                child: Icon(
                  note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 18,
                  color: note.isPinned ? Colors.orange : Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          
          Expanded(
            child: Text(
              note.content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Row(
            children: [
              if (hasReminder) const Icon(Icons.alarm, size: 16),

              if (attachmentCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file, size: 16),
                      const SizedBox(width: 4),
                      Text('$attachmentCount'),
                    ],
                  ),
                ),
            ],
          ),
          NoteTagChips(tags: note.tags),
        ],
      ),
    );
  }
}
