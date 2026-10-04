import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = '36fee2f83d44a7228bdf36b232be78e2';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ: แปลงข้อมูล JSON เป็น Weather model
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // กรณีค้นหาเมืองไม่พบ (404 Not Found)
        throw Exception('ไม่พบข้อมูลเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      } else if (response.statusCode == 401) {
        // กรณี API Key ไม่ถูกต้อง (401 Unauthorized)
        throw Exception('API Key ไม่ถูกต้องหรือไม่ได้รับอนุญาต');
      } else {
        // กรณีข้อผิดพลาดอื่น ๆ
        throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส ${response.statusCode})');
      }
    } on TimeoutException {
      // กรณีหมดเวลาการเชื่อมต่อ
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // กรณีไม่มีอินเทอร์เน็ตหรือไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // กรณี JSON ผิดรูปแบบ
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้องตามรูปแบบ');
    } catch (e) {
      rethrow;
    }
  }
}
