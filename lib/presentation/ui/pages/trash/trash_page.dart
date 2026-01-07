import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/selection/selection_cubit.dart';
import '../../../cubits/note/note_cubit.dart';

import 'widgets/trash_app_bar.dart';
import 'widgets/trash_body.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    // Load trash notes once when entering this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteCubit>().showTrash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<NoteCubit>().showAll(); // ✅ context còn sống
        }
      },
      child: BlocProvider(
        create: (_) => SelectionCubit(),
        child: Scaffold(
          appBar: const TrashAppBar(),
          body: const TrashBody(),
        ),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
  }
}
