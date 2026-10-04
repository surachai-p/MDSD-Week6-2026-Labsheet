import 'package:flutter_test/flutter_test.dart';
import 'package:week6_api_lab/main.dart';

void main() {
  testWidgets('Weather search page loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('ค้นหาสภาพอากาศ'), findsWidgets);
    expect(find.text('ค้นหา'), findsOneWidget);
  });
}
