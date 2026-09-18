import 'package:flutter_test/flutter_test.dart';
import 'package:week6_api_lab/main.dart';

void main() {
  testWidgets('shows the weather search interface', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ค้นหาสภาพอากาศ'), findsOneWidget);
    expect(find.text('ค้นหา'), findsOneWidget);
    expect(find.text('ทดสอบ POST (Checkpoint 3.1)'), findsOneWidget);
    expect(find.text('ทดสอบ PUT (Checkpoint 3.2)'), findsOneWidget);
  });
}
