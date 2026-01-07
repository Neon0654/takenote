import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/search/search_cubit.dart';
import '../../../../cubits/search/search_state.dart';

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

        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SearchLoaded) {
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (_, i) {
                    final note = state.results[i];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
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
}
