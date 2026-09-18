import 'services/demo_post_service.dart';

Future<void> main() async {
  print('เริ่มทดสอบ HTTP POST และ PUT\n');

  await createDemoPost();
  print('');
  await updateDemoPost();
}
