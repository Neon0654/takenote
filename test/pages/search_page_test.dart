import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes/presentation/pages/search_page.dart';

void main() {
  testWidgets('SearchPage renders search input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SearchPage()),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Lọc'), findsOneWidget);
  });
}
