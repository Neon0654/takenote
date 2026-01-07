import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/search/search_cubit.dart';
import '../../../cubits/search/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm')),
      body: Column(
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
      ),
    );
  }
}
