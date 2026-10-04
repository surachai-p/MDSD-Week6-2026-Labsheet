import 'services/demo_post_service.dart';

Future<void> main() async {
  print('--- ทดสอบเรียก HTTP PUT (ขั้นตอนที่ 3.2) ---');
  await updateDemoPost();
}
