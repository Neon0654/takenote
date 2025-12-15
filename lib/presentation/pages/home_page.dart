import 'package:flutter/material.dart';
import '../../data/models/note.dart';
import '../../data/models/tag.dart';
import 'search_page.dart';
import 'tag_management_page.dart';
import '../../utils/share_utils.dart';
import '../../data/database/notes_database.dart';
import '../../data/models/reminder.dart';
import 'package:intl/intl.dart';
import '../../utils/confirm_dialog.dart';


class HomePage extends StatelessWidget {
  final List<Note> notes;
  final Map<int, List<Tag>> noteTags;

  final List<Tag> tags;
  final Tag? selectedTag;
  final Function(Tag? tag) onSelectTag;

  final VoidCallback onAddNote;
  final Function(int id) onDeleteNote;
  final Function(int id) onTapNote;
  final Function(Note note) onTogglePin;

  

  const HomePage({
    super.key,
    required this.notes,
    required this.noteTags,
    required this.tags,
    required this.selectedTag,
    required this.onSelectTag,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.onTapNote,
    required this.onTogglePin,
  });

  String _formatDateTime(DateTime dt) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              const TextSpan(text: 'Quản lý ghi chú '),
              TextSpan(
                text: '(${notes.length})',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),


        actions: [
          IconButton(
            icon: const Icon(Icons.label),
            tooltip: 'Quản lý nhãn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TagManagementPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final noteId = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
              if (noteId != null) {
                onTapNote(noteId);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== TAG BAR =====
          if (tags.isNotEmpty)
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: selectedTag == null,
                      onSelected: (_) => onSelectTag(null),
                    ),
                  ),
                  ...tags.map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tag.name),
                        selected: selectedTag?.id == tag.id,
                        onSelected: (_) => onSelectTag(tag),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          // ===== NOTE LIST =====
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text('Chưa có ghi chú'))
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, index) {
                      final note = notes[index];
                      final tagsOfNote =
                          noteTags[note.id] ?? [];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(

                          
                          leading: IconButton(
                            icon: Icon(
                              note.isPinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                              color: note.isPinned
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            onPressed: () => onTogglePin(note),
                          ),
                          title: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                              // ===== REMINDER (HIỂN THỊ GIỐNG TAG) =====
                              FutureBuilder<List<Reminder>>(
  future: NotesDatabase.instance.getRemindersOfNote(note.id!),
  builder: (_, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SizedBox();
    }

    final reminders = snapshot.data!;
    final showList = reminders.take(2).toList();
    final moreCount = reminders.length - showList.length;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        children: [
          // 🔔 HIỂN THỊ TỐI ĐA 2 REMINDER
          ...showList.map(
            (r) => Chip(
              avatar: const Icon(
                Icons.alarm,
                size: 16,
                color: Colors.red,
              ),
              label: Text(
                _formatDateTime(r.remindAt),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.red.shade50,
              visualDensity: VisualDensity.compact,
            ),
          ),

          // ➕ NẾU CÒN NHIỀU HƠN
          if (moreCount > 0)
            Chip(
              label: Text(
                '+$moreCount',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.grey.shade300,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  },
),





                              if (tagsOfNote.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: -8,
                                    children: tagsOfNote
                                        .map(
                                          (tag) => Chip(
                                            label: Text(
                                              tag.name,
                                              style:
                                                  const TextStyle(
                                                      fontSize:
                                                          12),
                                            ),
                                            visualDensity:
                                                VisualDensity
                                                    .compact,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.share, color: Colors.blue),
      tooltip: 'Chia sẻ Zalo',
      onPressed: () {
        ShareUtils.shareNoteToZalo(note);
      },
    ),
    IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final ok = await showConfirmDialog(
          context: context,
          content: 'Xóa ghi chú này?',
        );

        if (ok) {
          onDeleteNote(note.id!);
        }
      },
    ),

  ],
),

                          
                          onTap: () =>
                              onTapNote(note.id!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
