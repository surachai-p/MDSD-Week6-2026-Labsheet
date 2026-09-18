import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week6_api_lab/main.dart';

void main() {
  testWidgets('WeatherSearchPage UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify AppBar title and widgets exist
    expect(find.text('ค้นหาสภาพอากาศ'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('ค้นหา'), findsOneWidget);
    expect(find.text('ทดลอง POST (ขั้นตอนที่ 3.1)'), findsOneWidget);
    expect(find.text('ทดลอง PUT (ขั้นตอนที่ 3.2)'), findsOneWidget);
    expect(find.text('ทดลอง Fake Store API (ขั้นตอนที่ 4.3)'), findsOneWidget);
    expect(find.text('ทดลอง Dio (ขั้นตอนที่ 5.3)'), findsOneWidget);
  });
}
