import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/folder_entity.dart';

import '../../../../domain/repositories/tag_repository.dart';
import '../../../../domain/repositories/note_repository.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/tag/tag_cubit.dart';

import '../../../cubits/selection/selection_cubit.dart';

import 'widgets/folder_notes_app_bar.dart';
import 'widgets/folder_notes_body.dart';

import '../selection/select_notes_page.dart';
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
          appBar: FolderAppBar(
            folderName: widget.folder.name,
            folderId: widget.folder.id!,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddNoteOptions(context),
            child: const Icon(Icons.add),
          ),
          body: FolderBody(
            folderId: widget.folder.id!,
            onOpenNote: (noteVM) async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotePage(note: noteVM.note)),
              );

              context.read<NoteCubit>().loadNotes();
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
}
