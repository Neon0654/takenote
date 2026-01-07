import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/note/note_cubit.dart';

/// Small, dumb Sort menu that calls `NoteCubit.setSort`.
class SortMenu extends StatelessWidget {
  const SortMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: (value) {
        switch (value) {
          case _SortOption.titleAz:
            context.read<NoteCubit>().setSort(NoteSortField.title, SortOrder.asc);
            break;
          case _SortOption.titleZa:
            context.read<NoteCubit>().setSort(NoteSortField.title, SortOrder.desc);
            break;
          case _SortOption.createdNewOld:
            context.read<NoteCubit>().setSort(NoteSortField.createdAt, SortOrder.desc);
            break;
          case _SortOption.createdOldNew:
            context.read<NoteCubit>().setSort(NoteSortField.createdAt, SortOrder.asc);
            break;
          case _SortOption.updatedNewOld:
            context.read<NoteCubit>().setSort(NoteSortField.updatedAt, SortOrder.desc);
            break;
          case _SortOption.updatedOldNew:
            context.read<NoteCubit>().setSort(NoteSortField.updatedAt, SortOrder.asc);
            break;
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _SortOption.titleAz, child: ListTile(title: Text('Tiêu đề A → Z'))),
        PopupMenuItem(value: _SortOption.titleZa, child: ListTile(title: Text('Tiêu đề Z → A'))),
        PopupMenuItem(value: _SortOption.createdNewOld, child: ListTile(title: Text('Tạo: mới → cũ'))),
        PopupMenuItem(value: _SortOption.createdOldNew, child: ListTile(title: Text('Tạo: cũ → mới'))),
        PopupMenuItem(value: _SortOption.updatedNewOld, child: ListTile(title: Text('Cập nhật: mới → cũ'))),
        PopupMenuItem(value: _SortOption.updatedOldNew, child: ListTile(title: Text('Cập nhật: cũ → mới'))),
      ],
    );
  }
}

enum _SortOption {
  titleAz,
  titleZa,
  createdNewOld,
  createdOldNew,
  updatedNewOld,
  updatedOldNew
}
