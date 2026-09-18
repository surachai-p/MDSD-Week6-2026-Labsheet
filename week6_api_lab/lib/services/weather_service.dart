import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  //static const _apiKey = 'df8caf4b7d05ad37f43f74aa50fd233d';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ: แปลง JSON เป็น Weather
        return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }

      if (response.statusCode == 404) {
        // กรณีไม่พบเมืองที่ร้องขอ
        throw Exception('ไม่พบข้อมูลสำหรับเมืองที่ระบุ');
      }

      // ข้อความทั่วไปสำหรับ status code อื่น ๆ
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (สถานะ ${response.statusCode})');
    } on TimeoutException {
      // การเชื่อมต่อหมดเวลา
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // ปัญหาการเชื่อมต่อพื้นฐาน (เช่น ไม่มีอินเทอร์เน็ต)
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // ข้อมูลที่ได้ไม่ใช่ JSON รูปแบบที่คาดหวัง
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
    } catch (e) {
      rethrow;
    }
  }
}