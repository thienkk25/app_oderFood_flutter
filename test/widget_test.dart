import 'package:app_oderfood/screens/welcome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    ));
    expect(find.text('Chào mừng tới Món ăn ngon'), findsOneWidget);
  });
}
