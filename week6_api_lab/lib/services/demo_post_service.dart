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

  print('--- ผลลัพธ์ HTTP POST (ขั้นตอนที่ 3.1) ---');
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
      'studentId': '67030115', // TODO: เปลี่ยนเป็นรหัสนักศึกษาของคุณ
      'studentName': 'Namthip Pomhin', // TODO: เปลี่ยนเป็นชื่อ-นามสกุลของคุณ
      'title': 'อัปเดตข้อมูลด้วย HTTP PUT',
      'body': 'แก้ไขข้อมูลสำเร็จแล้ว',
      'userId': 1,
    }),
  );

  print('\n--- ผลลัพธ์ HTTP PUT (ขั้นตอนที่ 3.2) ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}