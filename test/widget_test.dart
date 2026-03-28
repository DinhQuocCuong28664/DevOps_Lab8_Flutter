import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  // Test 1: Kiểm tra câu chào hiển thị đúng trên UI
  testWidgets('Greeting message is displayed correctly',
      (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // Tìm widget Text chứa nội dung greetingMessage
    expect(find.text(greetingMessage), findsOneWidget);
  });

  // Test 2: Kiểm tra greeting text có đúng Key không
  testWidgets('Greeting text has correct key', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('greeting_text')), findsOneWidget);
  });

  // Test 3: Kiểm tra counter bắt đầu từ 0
  testWidgets('Counter starts at 0', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
  });

  // Test 4: Kiểm tra counter tăng khi nhấn nút
  testWidgets('Counter increments when FAB is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify counter is now 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
