import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/presentation/pages/home_page.dart';
import 'package:notes/data/models/note.dart';

void main() {
  testWidgets('HomePage shows empty text when no notes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          notes: const [],
          onAddNote: () {},
          onDeleteNote: (_) {},
          onTapNote: (_) {},
        ),
      ),
    );

    expect(find.text('Chưa có ghi chú nào'), findsOneWidget);
  });

  testWidgets('HomePage renders note list', (tester) async {
    final notes = [
      Note(
        id: 1,
        title: 'Title',
        content: 'Content',
        createdAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          notes: notes,
          onAddNote: () {},
          onDeleteNote: (_) {},
          onTapNote: (_) {},
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });
}
