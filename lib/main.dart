import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/notification_service.dart';

import 'data/database/notes_database.dart';

import 'data/datasources/local/note/note_local_datasource_impl.dart';
import 'data/datasources/local/folder/folder_local_datasource_impl.dart';
import 'data/datasources/local/tag/tag_local_datasource_impl.dart';
import 'data/datasources/local/attachment/attachment_local_datasource_impl.dart';
import 'data/datasources/local/reminder/reminder_local_datasource_impl.dart';

import 'data/repositories_impl/note_repository_impl.dart';
import 'data/repositories_impl/folder_repository_impl.dart';
import 'data/repositories_impl/tag_repository_impl.dart';
import 'data/repositories_impl/attachment_repository_impl.dart';
import 'data/repositories_impl/reminder_repository_impl.dart';

import 'domain/repositories/note_repository.dart';
import 'domain/repositories/folder_repository.dart';
import 'domain/repositories/tag_repository.dart';
import 'domain/repositories/attachment_repository.dart';
import 'domain/repositories/reminder_repository.dart';

import 'presentation/cubits/note/note_cubit.dart';
import 'presentation/cubits/folder/folder_cubit.dart';
import 'presentation/cubits/search/search_cubit.dart';
import 'presentation/cubits/tag/tag_cubit.dart';
import 'presentation/ui/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await NotificationService.requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final database = NotesDatabase.instance;

    final noteLocalDataSource = NoteLocalDataSourceImpl(database);
    final folderLocalDataSource = FolderLocalDataSourceImpl(database);
    final tagLocalDataSource = TagLocalDataSourceImpl(database);
    final attachmentLocalDataSource =
        AttachmentLocalDataSourceImpl(database);
    final reminderLocalDataSource =
        ReminderLocalDataSourceImpl(database);

    final NoteRepository noteRepository = NoteRepositoryImpl(
      noteLocal: noteLocalDataSource,
      tagLocal: tagLocalDataSource,
      folderLocal: folderLocalDataSource,
    );

    final FolderRepository folderRepository =
        FolderRepositoryImpl(folderLocalDataSource);

    final TagRepository tagRepository =
        TagRepositoryImpl(tagLocalDataSource);

    final AttachmentRepository attachmentRepository =
        AttachmentRepositoryImpl(attachmentLocalDataSource);

    final ReminderRepository reminderRepository =
        ReminderRepositoryImpl(reminderLocalDataSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NoteRepository>(
          create: (_) => noteRepository,
        ),
        RepositoryProvider<TagRepository>(
          create: (_) => tagRepository,
        ),
        RepositoryProvider<FolderRepository>(
          create: (_) => folderRepository,
        ),
        RepositoryProvider<AttachmentRepository>(
          create: (_) => attachmentRepository,
        ),
        RepositoryProvider<ReminderRepository>(
          create: (_) => reminderRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NoteCubit(
              context.read<NoteRepository>(),
              context.read<TagRepository>(),
              context.read<AttachmentRepository>(),
              context.read<ReminderRepository>(),
            )..loadNotes(),
          ),
          BlocProvider(
            create: (context) =>
                FolderCubit(context.read<FolderRepository>())
                  ..loadFolders(),
          ),
          BlocProvider(
            create: (context) =>
                SearchCubit(context.read<NoteRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                TagCubit(context.read<TagRepository>())..loadTags(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Quản lý ghi chú',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
