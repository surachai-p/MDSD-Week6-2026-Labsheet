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

  print('POST Status Code: ${response.statusCode}');
  print('POST Response Body: ${response.body}');
}

Future<void> updateDemoPost() async {
  final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({
      'id': 1,
      'studentId': '67030116',
      'studentName': 'Nithi Thipprasoet',
      'title': 'แก้ไขข้อมูลด้วย HTTP PUT',
      'body': 'ทดสอบแก้ไขข้อมูลจาก Flutter',
      'userId': 1,
    }),
  );

  print('PUT Status Code: ${response.statusCode}');
  print('PUT Response Body: ${response.body}');
}
