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

  print('--- ผลลัพธ์ POST ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}

Future<void> updateDemoPost() async {
  // สังเกตว่า URL ของ PUT มักจะต้องระบุ ID ของสิ่งที่จะแก้ด้วย (ในที่นี้คือ /posts/1)
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'title': 'แก้ไขข้อมูล (PUT)',
      // TODO: เปลี่ยนเป็นรหัสและชื่อของคุณ
      'body': 'รหัสนักศึกษา: 67030323, ชื่อ: พรพรม สุขใจมิตร', 
      'userId': 1,
    }),
  );

  print('--- ผลลัพธ์ PUT ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}