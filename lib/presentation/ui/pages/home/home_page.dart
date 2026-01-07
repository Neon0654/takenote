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
}
