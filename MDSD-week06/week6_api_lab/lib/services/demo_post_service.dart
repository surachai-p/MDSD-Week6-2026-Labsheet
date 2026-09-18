import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'studentId': 67030270,
      'studentName': 'นายกฤษฏิณัช สำราญกิจ',
      'title': 'อัปเดตข้อมูลด้วย HTTP PUT',
      'body': 'ทดสอบการส่งข้อมูลด้วยวิธี PUT จาก Flutter',
      'userId': 1,
    }),
    
  );

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
      'studentId': '67030270',
      'studentName': 'กฤษฏิณัช สำราญกิจ',
      'title': 'อัปเดตข้อมูลด้วย HTTP PUT',
      'body': 'ทดสอบการส่งข้อมูลด้วยวิธี PUT จาก Flutter',
      'userId': 1,
    }),
  );

  print('--- [PUT] Response ---');
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}