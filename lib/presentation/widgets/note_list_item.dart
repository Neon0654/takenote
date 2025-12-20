import 'package:flutter/material.dart';
import '../../data/models/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggle;

  const NoteListItem({
    super.key,
    required this.note,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        onTap: selectionMode ? onToggle : onTap,
        onLongPress: onLongPress,
        leading: selectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
              )
            : null,
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
