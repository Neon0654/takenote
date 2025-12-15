import 'package:flutter/material.dart';
import '../../data/models/note.dart';
import '../../data/models/tag.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  final List<Note> notes;
  final Map<int, List<Tag>> noteTags; // ✅ CACHE TAG
  final VoidCallback onAddNote;
  final Function(int id) onDeleteNote;
  final Function(int id) onTapNote;
  final Function(Note note) onTogglePin;

  const HomePage({
    super.key,
    required this.notes,
    required this.noteTags,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.onTapNote,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý ghi chú'),
        actions: [
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
      body: notes.isEmpty
          ? const Center(child: Text('Chưa có ghi chú'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                final tags = noteTags[note.id] ?? [];

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
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (tags.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 6),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: -8,
                              children: tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        tag.name,
                                        style: const TextStyle(
                                            fontSize: 12),
                                      ),
                                      visualDensity:
                                          VisualDensity.compact,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () =>
                          onDeleteNote(note.id!),
                    ),
                    onTap: () => onTapNote(note.id!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
