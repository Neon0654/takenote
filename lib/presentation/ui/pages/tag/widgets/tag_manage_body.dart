import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/tag/tag_cubit.dart';
import '../../../../cubits/tag/tag_state.dart';

import '../dialogs/rename_tag_dialog.dart';
import '../dialogs/delete_tag_confirm_dialog.dart';

class TagManageBody extends StatelessWidget {
  const TagManageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagCubit, TagState>(
      builder: (context, state) {
        if (state is TagInitial || state is TagLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TagError) {
          return Center(child: Text(state.message));
        }

        if (state is TagLoaded) {
          if (state.tags.isEmpty) {
            return const Center(child: Text('Chưa có nhãn nào'));
          }

          return ListView.separated(
            itemCount: state.tags.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tag = state.tags[index];

              return ListTile(
                leading: const Icon(Icons.label),
                title: Text(tag.name),
                trailing: PopupMenuButton<_TagAction>(
                  onSelected: (value) {
                    switch (value) {
                      case _TagAction.rename:
                        _showRenameTagDialog(context, tag.id!, tag.name);
                        break;

                      case _TagAction.delete:
                        _confirmDeleteTag(context, tag.id!);
                        break;
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _TagAction.rename,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Đổi tên'),
                      ),
                    ),
                    PopupMenuItem(
                      value: _TagAction.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Xóa'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  void _confirmDeleteTag(BuildContext context, int tagId) {
    showDialog(
      context: context,
      builder: (_) => DeleteTagConfirmDialog(tagId: tagId),
    );
  }

  Future<void> _showRenameTagDialog(
    BuildContext context,
    int tagId,
    String oldName,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => RenameTagDialog(tagId: tagId, initialName: oldName),
    );
  }
}

enum _TagAction { rename, delete }