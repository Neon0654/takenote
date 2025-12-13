import 'package:flutter/material.dart';
import '../../data/models/note.dart';
import 'search_page.dart'; // ⬅️ thêm import

class HomePage extends StatelessWidget {
  final List<Note> notes;
  final VoidCallback onAddNote;
  final Function(int id) onDeleteNote;
  final Function(int id) onTapNote;

  const HomePage({
    super.key,
    required this.notes,
    required this.onAddNote,
    required this.onDeleteNote,
    required this.onTapNote,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Quản lý ghi chú",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),

        // ✅ ĐÚNG: actions
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final noteId = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchPage(),
                ),
              );

              if (noteId != null) {
                onTapNote(noteId); // ⬅️ GỌI CALLBACK
              }
            },
          ),
        ],
      ),

      body: notes.isEmpty
          ? const Center(
              child: Text(
                "Chưa có ghi chú nào",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteNote(note.id!),
                    ),
                    onTap: () => onTapNote(note.id!),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: onAddNote,
        backgroundColor: const Color.fromARGB(255, 188, 150, 223),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
