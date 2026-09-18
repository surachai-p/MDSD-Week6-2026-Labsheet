import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  // ⚠️ สำคัญ: เปลี่ยน YOUR_API_KEY ด้านล่างนี้เป็น API Key ของคุณเอง
  static const _apiKey = '50554256fd9f134975254f1cca724b2a';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      // ตั้งเวลา timeout 10 วินาที
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ: แปลงข้อความ JSON กลับมาเป็น Object Weather
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // กรณี 404: ไม่พบเมืองที่ค้นหา
        throw Exception('ไม่พบข้อมูลเมือง "$city" ที่คุณค้นหา');
      }
      
      // กรณี Error อื่นๆ จาก Server
      throw Exception('เกิดข้อผิดพลาดในการโหลดข้อมูล (รหัส: ${response.statusCode})');
      
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // ดักจับ FormatException กรณีข้อมูลที่ได้มาไม่ใช่ JSON ที่ถูกต้อง
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ');
    } catch (e) {
      rethrow;
    }
  }
}