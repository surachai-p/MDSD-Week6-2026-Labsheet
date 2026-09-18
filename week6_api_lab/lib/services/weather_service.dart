import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = '1ce7269a22b13c6fd94601fc80354644';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ แปลงข้อมูลด้วย Weather.fromJson
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // เพิ่มเงื่อนไขกรณี statusCode == 404
        throw Exception('ไม่พบข้อมูลเมืองที่ระบุ ($city)');
      }

      // โยน Exception พร้อมข้อความภาษาไทยที่เข้าใจง่ายสำหรับ status code อื่นๆ
      throw Exception('เกิดข้อผิดพลาดในการโหลดข้อมูล (รหัสสถานะ: ${response.statusCode})');
    } on TimeoutException {
      // แปลง error ที่ได้จากระบบ เป็นข้อความภาษาไทยที่อ่านเข้าใจง่าย
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // ดักจับกรณีเชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย (เช่น ไม่มีอินเทอร์เน็ต)
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // เพิ่มการดักจับ FormatException แยกต่างหาก สำหรับกรณี JSON ผิดรูปแบบ
      throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}

