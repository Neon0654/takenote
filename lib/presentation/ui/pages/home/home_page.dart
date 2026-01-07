import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/note/note_state.dart';

import '../../../cubits/tag/tag_cubit.dart';
import '../../../cubits/tag/tag_state.dart';

import '../../../cubits/selection/selection_cubit.dart';

import '../note/note_page.dart';
import '../../pages/home/widgets/home_app_bar.dart';
import '../../pages/home/widgets/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectionCubit(),
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: BlocBuilder<TagCubit, TagState>(
          buildWhen: (prev, curr) =>
              curr is TagLoaded || curr is TagError || curr is TagLoading,
          builder: (context, tagState) {
            return BlocBuilder<NoteCubit, NoteState>(
              builder: (context, noteState) {
                if (tagState is TagLoading || noteState is NoteLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (tagState is TagError || noteState is NoteError) {
                  final msg = tagState is TagError
                      ? tagState.message
                      : (noteState as NoteError).message;
                  return _buildCenteredInfo(
                    Icons.error_outline,
                    msg,
                    color: Colors.red,
                  );
                }

                if (tagState is TagLoaded && noteState is NoteLoaded) {
                  if (noteState.notes.isEmpty) {
                    return _buildCenteredInfo(
                      Icons.note_alt_outlined,
                      'Chưa có ghi chú nào',
                    );
                  }
                  return HomeBody(
                    notes: noteState.notes,
                    tags: tagState.tags,
                    selectedTagId: noteState.selectedTagId,
                    folderId: noteState.folderId,
                    onOpenNote: (noteVM) async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotePage(note: noteVM.note),
                        ),
                      );
                      context.read<NoteCubit>().loadNotes();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotePage()),
            );
            context.read<NoteCubit>().loadNotes();
          },
          label: const Text('Ghi chú'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCenteredInfo(IconData icon, String text, {Color? color}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color ?? Colors.grey),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(color: color ?? Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
