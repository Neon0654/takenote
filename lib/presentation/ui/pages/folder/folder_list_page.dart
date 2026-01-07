import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/note/note_cubit.dart';
import '../../../cubits/folder/folder_cubit.dart';
import '../../../cubits/folder/folder_state.dart';

import '../../../../domain/entities/folder_entity.dart';
import 'folder_notes_page.dart';

class FolderListPage extends StatelessWidget {
  const FolderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thư mục')),
      body: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          if (state is FolderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FolderError) {
            return Center(child: Text(state.message));
          }

          if (state is FolderLoaded) {
            if (state.folders.isEmpty) {
              return const Center(child: Text('Chưa có thư mục'));
            }

            return ListView.builder(
              itemCount: state.folders.length,
              itemBuilder: (_, index) {
                final folder = state.folders[index];
                final count = state.noteCount[folder.id] ?? 0;

                return _FolderTile(folder: folder, count: count);
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    int color = Colors.blue.value;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm thư mục'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Tên thư mục'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FolderCubit>().createFolder(controller.text, color);
              Navigator.pop(context);
              context.read<NoteCubit>().showFolder(null);
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
  final FolderEntity folder;
  final int count;

  const _FolderTile({required this.folder, required this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.folder, color: Color(folder.colorValue)),
      title: Text(folder.name),
      subtitle: Text('$count ghi chú'),

      trailing: PopupMenuButton<_FolderMenu>(
        onSelected: (value) {
          switch (value) {
            case _FolderMenu.rename:
              _showRenameDialog(context);
              break;
            case _FolderMenu.delete:
              _confirmDelete(context);
              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: _FolderMenu.rename,
            child: ListTile(leading: Icon(Icons.edit), title: Text('Đổi tên')),
          ),
          PopupMenuItem(
            value: _FolderMenu.delete,
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Xóa'),
            ),
          ),
        ],
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FolderNotesPage(folder: folder)),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: folder.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đổi tên thư mục'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Tên thư mục'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FolderCubit>().renameFolder(
                folder.id!,
                controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa thư mục'),
        content: Text('Xóa "${folder.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<FolderCubit>().deleteFolder(folder.id!);
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
enum _FolderMenu { rename, delete }

