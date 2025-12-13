import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Quản lý ghi chú')),
          floatingActionButton: FloatingActionButton(onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Quản lý ghi chú'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
