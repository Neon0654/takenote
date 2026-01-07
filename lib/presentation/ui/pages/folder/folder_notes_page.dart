import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/folder_entity.dart';

import '../../../../domain/repositories/tag_repository.dart';
import '../../../../domain/repositories/note_repository.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/note/note_state.dart';
import '../../../cubits/tag/tag_cubit.dart';
import '../../../cubits/tag/tag_state.dart';

import '../../../cubits/selection/selection_cubit.dart';
import '../../../cubits/selection/selection_state.dart';

import '../../../ui/widgets/note_grid.dart';
import '../../../ui/widgets/tag_bar.dart';

import '../../../ui/pages/note/select_notes_page.dart';
import '../../../ui/pages/note/note_page.dart';

import '../../../../data/repositories_impl/attachment_repository_impl.dart';
import '../../../../data/repositories_impl/reminder_repository_impl.dart';

class FolderNotesPage extends StatefulWidget {
  final FolderEntity folder;
  const FolderNotesPage({super.key, required this.folder});

  @override
  State<FolderNotesPage> createState() => _FolderNotesPageState();
}

class _FolderNotesPageState extends State<FolderNotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().showFolder(widget.folder.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<NoteCubit>()),
        BlocProvider.value(value: context.read<TagCubit>()),
        BlocProvider(create: (_) => SelectionCubit()),
      ],
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            context.read<NoteCubit>().showAll();
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteOptions(context),
            child: const Icon(Icons.add),
          ),
          body: BlocBuilder<TagCubit, TagState>(
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
                          tags: tagState.tags, // ✅ lấy từ TagCubit
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
        ),
      ),
    );
  }

  void _showAddNoteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Chuyển ghi chú có sẵn'),
                onTap: () {
                  Navigator.pop(context);
                  _openMoveNotesPage(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('Thêm ghi chú mới'),
                onTap: () {
                  Navigator.pop(context);
                  _openCreateNotePage(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMoveNotesPage(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => NoteCubit(
                context.read<NoteRepository>(),
                context.read<TagRepository>(),
                context.read<AttachmentRepositoryImpl>(),
                context.read<ReminderRepositoryImpl>(),
              )..showUnassigned(),
            ),
            BlocProvider(create: (_) => SelectionCubit()),
          ],
          child: SelectNotesPage(targetFolderId: widget.folder.id),
        ),
      ),
    );

    if (result == true) {
      context.read<NoteCubit>().showFolder(widget.folder.id);
    }
  }

  void _openCreateNotePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NotePage(folderId: widget.folder.id)),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<SelectionCubit, SelectionState>(
        builder: (context, selection) {
          if (!selection.selecting) {
            return AppBar(title: Text(widget.folder.name));
          }

          final selectedCount = selection.selectedIds.length;

          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.read<SelectionCubit>().clear(),
            ),
            title: Text('$selectedCount đã chọn'),
            actions: [
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
              PopupMenuButton<_NoteAction>(
                onSelected: (value) async {
                  final ids = context.read<SelectionCubit>().state.selectedIds;
                  final noteCubit = context.read<NoteCubit>();

                  switch (value) {
                    case _NoteAction.moveOut:
                      await noteCubit.moveNotesToFolder(
                        noteIds: ids,
                        folderId: null,
                      );
                      noteCubit.showFolder(widget.folder.id);
                      break;

                    case _NoteAction.delete:
                      await noteCubit.deleteNotes(ids);
                      noteCubit.showFolder(widget.folder.id);
                      break;
                  }

                  context.read<SelectionCubit>().clear();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _NoteAction.moveOut,
                    child: ListTile(
                      leading: Icon(Icons.drive_file_move),
                      title: Text('Chuyển ra ngoài'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _NoteAction.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Xóa'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _NoteAction { moveOut, delete }
