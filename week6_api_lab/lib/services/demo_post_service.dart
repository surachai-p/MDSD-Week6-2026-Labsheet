import 'dart:convert';
import 'package:http/http.dart' as http;

// ฟังก์ชันเดิมจากขั้นตอนที่ 3.1
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

  print('Status Code (POST): ${response.statusCode}');
  print('Response Body (POST): ${response.body}');
}

// ✅ ฟังก์ชันใหม่สำหรับขั้นตอนที่ 3.2 (ใช้ PUT)
Future<void> updateDemoPost() async {
  // เปลี่ยน URL เพื่อเจาะจงไปที่ข้อมูล id = 1
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'title': 'อัปเดตข้อมูลด้วย HTTP PUT',
      // TODO: เปลี่ยนตัวเลข 67030085 ด้านล่างนี้ ให้เป็นรหัสนักศึกษาจริงของคุณ
      'body': 'รหัสนักศึกษา: 67030085, ชื่อ: Thanut-orn Sripoohtron', 
      'userId': 1,
    }),
  );

  print('Status Code (PUT): ${response.statusCode}');
  print('Response Body (PUT): ${response.body}');
}