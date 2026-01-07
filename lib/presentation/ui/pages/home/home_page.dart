import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/note/note_state.dart';

import '../../../cubits/tag/tag_cubit.dart';
import '../../../cubits/tag/tag_state.dart';

import '../../../cubits/selection/selection_cubit.dart';

import '../../widgets/note_grid.dart';
import '../../widgets/tag_bar.dart';
import '../../widgets/multi_note_tag_dialog.dart';

import '../note/note_page.dart';
import '../folder/folder_list_page.dart';
import '../home/TagManagementPage.dart';
import '../search/search_page.dart';
import '../home/trash_page.dart';
import '../../../cubits/selection/selection_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectionCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<SelectionCubit, SelectionState>(
            builder: (context, selection) {
              if (!selection.selecting) {
                return _buildNormalAppBar(context);
              } else {
                return _buildSelectionAppBar(context, selection);
              }
            },
          ),
        ),

        body: BlocBuilder<TagCubit, TagState>(
          buildWhen: (prev, curr) => curr is TagLoaded,
          builder: (context, tagState) {
            return BlocBuilder<NoteCubit, NoteState>(
              builder: (context, noteState) {
                // ===== LOADING =====
                if (tagState is TagInitial ||
                    tagState is TagLoading ||
                    noteState is NoteInitial ||
                    noteState is NoteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ===== ERROR =====
                if (tagState is TagError) {
                  return Center(child: Text(tagState.message));
                }

                if (noteState is NoteError) {
                  return Center(child: Text(noteState.message));
                }

                // ===== LOADED =====
                if (tagState is TagLoaded && noteState is NoteLoaded) {
                  return Column(
                    children: [
                      TagBar(
                        tags: tagState.tags,
                        selectedTagId: noteState.selectedTagId,
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: NoteGrid(
                          notes: noteState.notes,
                          onOpenNote: (noteVM) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotePage(note: noteVM.note),
                              ),
                            );

                            context.read<NoteCubit>().loadNotes();
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotePage()),
            );

            context.read<NoteCubit>().loadNotes();
          },

          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Ghi chú'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            );
          },
        ),

        PopupMenuButton<_HomeMenu>(
          onSelected: (value) {
            switch (value) {
              case _HomeMenu.folder:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FolderListPage()),
                );
                break;

              case _HomeMenu.tag:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TagManagementPage()),
                );
                break;

              case _HomeMenu.trash:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrashPage()),
                );
                break;
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _HomeMenu.folder,
              child: ListTile(
                leading: Icon(Icons.folder),
                title: Text('Thư mục'),
              ),
            ),
            PopupMenuItem(
              value: _HomeMenu.tag,
              child: ListTile(leading: Icon(Icons.label), title: Text('Nhãn')),
            ),
            PopupMenuItem(
              value: _HomeMenu.trash,
              child: ListTile(leading: Icon(Icons.delete), title: Text('Thùng rác')),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(
    BuildContext context,
    SelectionState selection,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          context.read<SelectionCubit>().clear();
        },
      ),
      title: Text('${selection.selectedIds.length} đã chọn'),
      actions: [
        // ☑️ CHỌN TẤT CẢ
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: () {
            final state = context.read<NoteCubit>().state;
            if (state is! NoteLoaded) return;

            context.read<SelectionCubit>().selectAll(
              state.notes.map((e) => e.note.id!).toList(),
            );
          },
        ),

        // 🏷️ GẮN NHÃN (CHỈ HIỆN KHI SELECTING)
        IconButton(
          icon: const Icon(Icons.label),
          onPressed: selection.selectedIds.isEmpty
              ? null
              : () async {
                  await showDialog(
                    context: context,
                    builder: (_) =>
                        MultiNoteTagDialog(noteIds: selection.selectedIds),
                  );

                  context.read<NoteCubit>().loadNotes();
                  context.read<SelectionCubit>().clear();
                },
        ),
      ],
    );
  }
}

enum _HomeMenu { folder, tag, trash }
