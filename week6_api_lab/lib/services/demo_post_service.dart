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

  print('--- ผลลัพธ์จากการกดปุ่ม POST ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

Future<void> updateDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'title': 'อัปเดตข้อมูลโดย ภูวิชญ์ ประกอบจิตร',
      'body': 'รหัสนักศึกษา: 67030183',
      'userId': 1,
    }),
  );

  print('--- ผลลัพธ์จากการกดปุ่ม PUT ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}
