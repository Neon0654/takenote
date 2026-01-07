import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/presentation/ui/pages/edit_note_page.dart';
import 'package:notes/data/models/note_model.dart';

void main() {
  testWidgets('EditNotePage shows correct title for add', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditNotePage(
          onSave: (_, __) {},
        ),
      ),
    );

    expect(find.text('Thêm ghi chú'), findsOneWidget);
  });

  testWidgets('EditNotePage loads note data when editing', (tester) async {
    final note = Note(
      id: 1,
      title: 'Hello',
      content: 'World',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: EditNotePage(
          note: note,
          onSave: (_, __) {},
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
  });
}
