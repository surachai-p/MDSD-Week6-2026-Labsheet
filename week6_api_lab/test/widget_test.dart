// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:week6_api_lab/main.dart';

void main() {
  testWidgets('แสดงหน้าค้นหาสภาพอากาศ', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ค้นหาสภาพอากาศ'), findsOneWidget);
    expect(find.text('ชื่อเมือง'), findsOneWidget);
    expect(find.text('ค้นหา'), findsOneWidget);
  });
}
