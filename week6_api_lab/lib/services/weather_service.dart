import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = '1cdb159de4a6e62aea2625f46f5a1941'; 

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ: แปลง JSON เป็น Weather Object
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // กรณีหาเมืองไม่พบ
        throw Exception('ไม่พบข้อมูลเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }

      // กรณี Error อื่นๆ
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (${response.statusCode})');
    } on TimeoutException {
      // ดักจับกรณีเชื่อมต่อหมดเวลา
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // ดักจับกรณีไม่มีอินเทอร์เน็ต
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // ดักจับกรณี JSON ผิดรูปแบบ
      throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}