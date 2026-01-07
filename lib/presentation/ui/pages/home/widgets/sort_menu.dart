import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/note/note_cubit.dart';


class SortMenu extends StatelessWidget {
  const SortMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SortOption>(
      icon: const Icon(Icons.sort_rounded),
      tooltip: 'Sắp xếp',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        final cubit = context.read<NoteCubit>();
        switch (value) {
          case _SortOption.titleAz:
            cubit.setSort(NoteSortField.title, SortOrder.asc);
            break;
          case _SortOption.titleZa:
            cubit.setSort(NoteSortField.title, SortOrder.desc);
            break;
          case _SortOption.createdNewOld:
            cubit.setSort(NoteSortField.createdAt, SortOrder.desc);
            break;
          case _SortOption.createdOldNew:
            cubit.setSort(NoteSortField.createdAt, SortOrder.asc);
            break;
          case _SortOption.updatedNewOld:
            cubit.setSort(NoteSortField.updatedAt, SortOrder.desc);
            break;
          case _SortOption.updatedOldNew:
            cubit.setSort(NoteSortField.updatedAt, SortOrder.asc);
            break;
        }
      },
      itemBuilder: (_) => [
        _buildItem(_SortOption.titleAz, Icons.sort_by_alpha, 'Tiêu đề A → Z'),
        _buildItem(_SortOption.titleZa, Icons.sort_by_alpha, 'Tiêu đề Z → A'),
        const PopupMenuDivider(),
        _buildItem(
          _SortOption.createdNewOld,
          Icons.calendar_today,
          'Tạo: mới nhất',
        ),
        _buildItem(
          _SortOption.createdOldNew,
          Icons.calendar_today_outlined,
          'Tạo: cũ nhất',
        ),
        const PopupMenuDivider(),
        _buildItem(
          _SortOption.updatedNewOld,
          Icons.edit_calendar,
          'Cập nhật: mới nhất',
        ),
        _buildItem(
          _SortOption.updatedOldNew,
          Icons.edit_calendar_outlined,
          'Cập nhật: cũ nhất',
        ),
      ],
    );
  }

  PopupMenuItem<_SortOption> _buildItem(
    _SortOption value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

enum _SortOption {
  titleAz,
  titleZa,
  createdNewOld,
  createdOldNew,
  updatedNewOld,
  updatedOldNew,
}
