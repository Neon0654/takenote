import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/search/search_cubit.dart';
import '../../../../cubits/search/search_state.dart';
import '../../../../cubits/search/search_time_filter.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Nhập từ khóa...',
          ),
          onChanged: (value) {
            context.read<SearchCubit>().search(value);
          },
        ),

        const SizedBox(height: 8),

        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _filterChip(context, state, 'Tất cả', SearchTimeFilter.all),
                  _filterChip(context, state, 'Hôm qua', SearchTimeFilter.yesterday),
                  _filterChip(context, state, '7 ngày', SearchTimeFilter.last7Days),
                  _filterChip(context, state, '30 ngày', SearchTimeFilter.last30Days),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SearchLoaded) {
                if (state.results.isEmpty) {
                  return const Center(child: Text('Không có kết quả'));
                }

                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (_, i) {
                    final note = state.results[i];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _filterChip(
    BuildContext context,
    SearchState state,
    String label,
    SearchTimeFilter filter,
  ) {
    final isSelected = state.filter == filter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade400,
        ),
        onSelected: (_) {
          context.read<SearchCubit>().setFilter(filter);
        },
      ),
    );
  }
}
