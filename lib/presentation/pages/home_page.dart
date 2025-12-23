import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/note.dart';
import '../../data/models/tag.dart';
import '../../data/models/reminder.dart';
import '../../data/database/notes_database.dart';

import '../../utils/confirm_dialog.dart';
import '../../controllers/selection_controller.dart';

import 'search_page.dart';
import 'tag_management_page.dart';
import 'trash_page.dart';
import 'create_folder_dialog.dart';
import 'folder_list_page.dart';
import '../../data/models/folder.dart';
import '../../data/models/folder.dart';
import '../../data/database/notes_database.dart';


class HomePage extends StatefulWidget {
  final bool isFolderMode;
  final List<Note> notes;
  final Map<int, List<Tag>> noteTags;

  final List<Tag> tags;
  final Tag? selectedTag;
  final Function(Tag? tag) onSelectTag;

  final VoidCallback onAddNote;
  final Function(int id) onTapNote;
  final Function(Note note) onTogglePin;
  
  final Folder? folder;


  final Future<void> Function() onRefresh;

  const HomePage({
    super.key,
    required this.notes,
    required this.noteTags,
    required this.tags,
    required this.selectedTag,
    required this.onSelectTag,
    required this.onAddNote,
    required this.onTapNote,
    required this.onTogglePin,
    required this.onRefresh,
    this.isFolderMode = false,
    this.folder,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SelectionController selectionController = SelectionController();

  // ================= MOVE TO TRASH (MULTI) =================
  Future<void> _moveSelectedToTrash() async {
    final count = selectionController.selectedIds.length;
    if (count == 0) return;

    final ok = await showConfirmDialog(
      context: context,
      content: 'Chuyển $count ghi chú vào thùng rác?',
    );
    if (!ok) return;

    for (final id in selectionController.selectedIds) {
      await NotesDatabase.instance.moveNoteToTrash(id);
    }

    selectionController.clear();
    await widget.onRefresh();
  }

  Future<void> _moveSelectedNotes() async {
    final ids = selectionController.selectedIds;
    if (ids.isEmpty) return;

    final folders = await NotesDatabase.instance.fetchFolders();

    final folderId = await showDialog<int?>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Di chuyển ghi chú'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('📂 Ngoài thư mục'),
          ),
          const Divider(),
          ...folders.map(
            (f) => SimpleDialogOption(
              onPressed: () => Navigator.pop(context, f.id),
              child: Row(
                children: [
                  Icon(Icons.folder, color: Color(f.color)),
                  const SizedBox(width: 8),
                  Text(f.name),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (folderId == null && !mounted) return;

    for (final id in ids) {
      await NotesDatabase.instance.moveNoteToFolder(
        noteId: id,
        folderId: folderId,
      );
    }

    selectionController.clear();
    await widget.onRefresh();
  }


  @override
  Widget build(BuildContext context) {
    final notes = widget.notes;

    return AnimatedBuilder(
      animation: selectionController,
      builder: (_, __) {
        return Scaffold(
          // ================= APP BAR =================
          appBar: AppBar(
            leading: selectionController.isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: selectionController.clear,
                  )
                : null,
            title: Text(
              selectionController.isSelectionMode
                  ? '${selectionController.selectedIds.length} đã chọn'
                  : widget.isFolderMode
                      ? 'Ghi chú trong thư mục'
                      : 'Quản lý ghi chú (${notes.length})',
            ),

            // ================= ACTIONS =================
            actions: selectionController.isSelectionMode
              ? [
                  IconButton(
                    tooltip: 'Di chuyển',
                    icon: const Icon(Icons.drive_file_move_outline),
                    onPressed: _moveSelectedNotes,
                  ),
                  IconButton(
                    tooltip: 'Chọn tất cả',
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      selectionController.selectAll(
                        notes.map((e) => e.id!).toList(),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Xóa',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _moveSelectedToTrash,
                  ),
                ]

                : widget.isFolderMode
        ? [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    await showDialog(
                      context: context,
                      builder: (_) => CreateFolderDialog(
                        folder: widget.folder!,
                      ),
                    );
                    await widget.onRefresh();
                    break;

                  case 'search':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPage(),
                      ),
                    );
                    break;

                  case 'trash':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TrashPage(),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Chỉnh sửa'),
                  ),
                ),
                PopupMenuItem(
                  value: 'search',
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Tìm kiếm'),
                  ),
                ),
                PopupMenuItem(
                  value: 'trash',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Thùng rác'),
                  ),
                ),
              ],
            ),
          ]
                    // ===== MENU HOME =====
                    : [
                        IconButton(
                          icon: const Icon(Icons.folder),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const FolderListPage(),
                              ),
                            );
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            switch (value) {
                              case 'search':
                                final noteId =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SearchPage(),
                                  ),
                                );
                                if (noteId != null) {
                                  widget.onTapNote(noteId);
                                }
                                break;

                              case 'tags':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TagManagementPage(),
                                  ),
                                );
                                break;

                              case 'folder':
                                await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const CreateFolderDialog(),
                                );
                                break;

                              case 'trash':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TrashPage(),
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'search',
                              child: ListTile(
                                leading: Icon(Icons.search),
                                title: Text('Tìm kiếm'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'tags',
                              child: ListTile(
                                leading: Icon(Icons.label),
                                title: Text('Quản lý nhãn'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'folder',
                              child: ListTile(
                                leading: Icon(Icons.folder),
                                title: Text('Thêm thư mục'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'trash',
                              child: ListTile(
                                leading:
                                    Icon(Icons.delete_outline),
                                title: Text('Thùng rác'),
                              ),
                            ),
                          ],
                        ),
                      ],
          ),

          // ================= BODY =================
          body: Column(
            children: [
              // ===== TAG BAR (CHỈ HOME) =====
              if (!widget.isFolderMode)
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      ChoiceChip(
                        label: const Text('Tất cả'),
                        selected: widget.selectedTag == null,
                        onSelected: (_) =>
                            widget.onSelectTag(null),
                      ),
                      const SizedBox(width: 8),
                      ...widget.tags.map(
                        (tag) => Padding(
                          padding:
                              const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(tag.name),
                            selected:
                                widget.selectedTag?.id ==
                                    tag.id,
                            onSelected: (_) =>
                                widget.onSelectTag(tag),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Divider(height: 1),

              // ===== GRID NOTE =====
              Expanded(
                child: notes.isEmpty
                    ? const Center(
                        child: Text('Chưa có ghi chú'),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (_, index) {
                          final note = notes[index];
                          final tagsOfNote =
                              widget.noteTags[note.id] ?? [];

                          return GestureDetector(
                            onTap:
                                selectionController.isSelectionMode
                                    ? () => selectionController
                                        .toggle(note.id!)
                                    : () => widget
                                        .onTapNote(note.id!),
                            onLongPress: () =>
                                selectionController
                                    .startSelection(note.id!),
                            child: Container(
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectionController
                                        .isSelected(note.id!)
                                    ? Colors.blue.shade50
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                  color: note.isPinned
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          note.title,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            widget.onTogglePin(
                                                note),
                                        child: Icon(
                                          note.isPinned
                                              ? Icons.push_pin
                                              : Icons
                                                  .push_pin_outlined,
                                          size: 18,
                                          color: note.isPinned
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    child: Text(
                                      note.content,
                                      maxLines: 4,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                  ),
                                  _buildReminder(note),
                                  if (tagsOfNote.isNotEmpty)
                                    Wrap(
                                      spacing: 4,
                                      children: tagsOfNote
                                          .take(3)
                                          .map(
                                            (t) => Chip(
                                              label: Text(
                                                t.name,
                                                style:
                                                    const TextStyle(
                                                        fontSize:
                                                            10),
                                              ),
                                              visualDensity:
                                                  VisualDensity
                                                      .compact,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  _buildDate(note),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          floatingActionButton:
              selectionController.isSelectionMode
                  ? null
                  : FloatingActionButton(
                      onPressed: widget.onAddNote,
                      child: const Icon(Icons.add),
                    ),
        );
      },
    );
  }

  // ================= REMINDER =================
  Widget _buildReminder(Note note) {
    return FutureBuilder<List<Reminder>>(
      future:
          NotesDatabase.instance.getRemindersOfNote(note.id!),
      builder: (_, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final list = snapshot.data!;
        final first = list.first;
        final more = list.length - 1;

        return Wrap(
          spacing: 4,
          children: [
            Chip(
              avatar: const Icon(Icons.alarm,
                  size: 14, color: Colors.red),
              label: Text(
                DateFormat('dd/MM HH:mm')
                    .format(first.remindAt),
                style:
                    const TextStyle(fontSize: 11),
              ),
              visualDensity:
                  VisualDensity.compact,
            ),
            if (more > 0)
              Chip(
                label: Text(
                  '+$more',
                  style:
                      const TextStyle(fontSize: 11),
                ),
                visualDensity:
                    VisualDensity.compact,
              ),
          ],
        );
      },
    );
  }

  // ================= DATE =================
  Widget _buildDate(Note note) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        DateFormat('dd/MM/yyyy')
            .format(note.createdAt),
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
