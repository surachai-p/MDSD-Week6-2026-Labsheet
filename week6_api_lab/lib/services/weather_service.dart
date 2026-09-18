import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  // นำ API Key ของคุณมาใส่แทนที่ YOUR_API_KEY
  static const _apiKey = 'a23f6757b2e529d1edaee3c5ce0154c1';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ แปลงข้อมูลด้วย Weather.fromJson
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // เพิ่มเงื่อนไขกรณี statusCode == 404
        throw Exception('ไม่พบข้อมูลสภาพอากาศของเมืองที่คุณค้นหา');
      }
      
      // กรณีเกิด Error อื่นๆ ที่ไม่ใช่ 404
      throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูล (รหัส: ${response.statusCode})');
      
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // เพิ่มการดักจับ FormatException สำหรับกรณี JSON ผิดรูปแบบ
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ ไม่สามารถประมวลผลได้');
    } catch (e) {
      rethrow;
    }
  }
}