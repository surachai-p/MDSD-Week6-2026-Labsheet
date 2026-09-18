import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'title': 'ทดสอบส่งข้อมูลจาก Flutter',
      'body': 'นี่คือเนื้อหาที่ส่งด้วย HTTP POST',
      'userId': 1,
    }),
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

// ฟังก์ชันสำหรับขั้นตอนที่ 3.2 (HTTP PUT)
Future<void> updateDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'studentId': '67030030', // TODO: เปลี่ยนเป็นรหัสนักศึกษาของคุณ
      'studentName':
          'นายโกศล เพ็งพิพัฒน์', // TODO: เปลี่ยนเป็นชื่อ-นามสกุลของคุณ
      'title': 'แก้ไขข้อมูลด้วย HTTP PUT',
      'body': 'อัปเดตข้อมูลนักศึกษาเรียบร้อยแล้ว',
      'userId': 1,
    }),
  );

  print('Status Code (PUT): ${response.statusCode}');
  print('Response Body (PUT): ${response.body}');
}
