// import 'package:flutter/material.dart';

// import '../data/database/notes_database.dart';
// import '../data/models/note_model.dart';
// import '../data/models/tag_model.dart';
// import '../presentation/ui/pages/home_page.dart';
// import '../presentation/ui/pages/edit_note_page.dart';
// import '../data/models/folder_model.dart';


// class NotesController extends StatefulWidget {
//   /// NULL = HOME | != null = FOLDER
//   final int? folderId;
//   final Folder? folder;

//   /// true khi đang ở trong folder
//   final bool isFolderMode;

// const NotesController({
//   super.key,
//   this.folderId,
//   this.folder,
//   this.isFolderMode = false,
// });


//   @override
//   State<NotesController> createState() => _NotesControllerState();
// }

// class _NotesControllerState extends State<NotesController> {
//   List<Note> notes = [];
//   Map<int, List<Tag>> noteTags = {};

//   List<Tag> allTags = [];
//   Tag? selectedTag;

//   @override
//   void initState() {
//     super.initState();
//     loadNotes();
//   }

//   // ================= LOAD NOTES =================
//   Future<void> loadNotes() async {
//     List<Note> loadedNotes;

//     if (widget.folderId != null) {
//       // ===== FOLDER MODE =====
//       loadedNotes = await NotesDatabase.instance
//           .fetchNotesByFolder(widget.folderId!);
//     } else {
//       // ===== HOME MODE =====
//       if (selectedTag == null) {
//         loadedNotes = await NotesDatabase.instance
//             .fetchNotesWithoutFolder();
//       } else {
//         loadedNotes = await NotesDatabase.instance
//             .getNotesByTag(selectedTag!.id!);
//       }
//     }

//     final tags = await NotesDatabase.instance.fetchTags();
//     final tagsOfNotes = <int, List<Tag>>{};

//     for (final note in loadedNotes) {
//       if (note.id == null) continue;
//       tagsOfNotes[note.id!] =
//           await NotesDatabase.instance.getTagsOfNote(note.id!);
//     }

//     if (!mounted) return;

//     setState(() {
//       notes = loadedNotes;
//       allTags = tags;
//       noteTags = tagsOfNotes;
//     });
//   }

//   // ================= TAG FILTER (HOME ONLY) =================
//   void onSelectTag(Tag? tag) {
//     if (widget.isFolderMode) return;
//     selectedTag = tag;
//     loadNotes();
//   }

//   // ================= ADD NOTE =================
//   Future<void> addNote(String title, String content) async {
//     final noteId = await NotesDatabase.instance.createNote(
//       Note(
//         title: title,
//         content: content,
//         createdAt: DateTime.now(),
//       ),
//     );

//     // chỉ gán folder khi đang ở folder
//     if (widget.folderId != null) {
//       await NotesDatabase.instance.linkNoteToFolder(
//         noteId,
//         widget.folderId!,
//       );
//     }

//     await loadNotes();
//   }

//   // ================= UPDATE NOTE =================
//   Future<void> updateNote(
//     int id,
//     String title,
//     String content,
//   ) async {
//     final old = await NotesDatabase.instance.getNoteById(id);
//     if (old == null) return;

//     await NotesDatabase.instance.updateNote(
//       Note(
//         id: id,
//         title: title,
//         content: content,
//         createdAt: old.createdAt,
//         isPinned: old.isPinned,
//         isDeleted: old.isDeleted,
//       ),
//     );

//     await loadNotes();
//   }

//   // ================= PIN =================
//   Future<void> togglePin(Note note) async {
//     await NotesDatabase.instance.updateNote(
//       Note(
//         id: note.id,
//         title: note.title,
//         content: note.content,
//         createdAt: note.createdAt,
//         isPinned: !note.isPinned,
//         isDeleted: note.isDeleted,
//       ),
//     );

//     await loadNotes();
//   }

//   // ================= ADD PAGE =================
//   void openAddNotePage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditNotePage(
//           onSave: addNote,
//         ),
//       ),
//     );
//   }

//   // ================= EDIT PAGE =================
//   void openEditNotePage(int id) async {
//     final note = await NotesDatabase.instance.getNoteById(id);
//     if (note == null) return;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditNotePage(
//           note: note,
//           onSave: (title, content) {
//             updateNote(note.id!, title, content);
//           },
//         ),
//       ),
//     );
//   }

//   // ================= BUILD =================
//   @override
//   Widget build(BuildContext context) {
//     return HomePage(
//       notes: notes,
//       noteTags: noteTags,
//       tags: allTags,
//       selectedTag: selectedTag,
//       onSelectTag: onSelectTag,
//       onAddNote: openAddNotePage,
//       onTapNote: openEditNotePage,
//       onTogglePin: togglePin,

//       /// quan trọng
//       isFolderMode: widget.isFolderMode,

//       folder: widget.folder, 
//       /// dùng để refresh khi xóa nhiều
//       onRefresh: loadNotes,
//     );
//   }
// }
