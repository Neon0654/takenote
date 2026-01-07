import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/tag/tag_cubit.dart';
import '../../../cubits/tag/tag_state.dart';
import '../../../cubits/note/note_cubit.dart';

class TagManagementPage extends StatelessWidget {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý nhãn')),
      body: BlocBuilder<TagCubit, TagState>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTagDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showAddTagDialog(BuildContext context) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm nhãn'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tên nhãn'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TagCubit>().createTag(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTag(BuildContext context, int tagId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa nhãn'),
        content: const Text(
          'Nhãn này sẽ bị gỡ khỏi tất cả ghi chú. Bạn có chắc không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TagCubit>().deleteTag(tagId);
              context.read<NoteCubit>().loadNotes();
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameTagDialog(
    BuildContext context,
    int tagId,
    String oldName,
  ) async {
    final controller = TextEditingController(text: oldName);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đổi tên nhãn'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tên nhãn mới'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;

              context.read<TagCubit>().renameTag(tagId, newName);
              context.read<NoteCubit>().loadNotes();
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

enum _TagAction { rename, delete }
