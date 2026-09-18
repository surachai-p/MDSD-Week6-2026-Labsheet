import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey =
      '1c4628c3d8951db7c9dc77b4944b31be'; // ใส่ API Key ของคุณ

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ: แปลงข้อมูลด้วย Weather.fromJson
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // ดักจับกรณีไม่พบชื่อเมือง
        throw Exception(
          'ไม่พบข้อมูลเมืองที่คุณค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง',
        );
      }

      // กรณี Error อื่นๆ
      throw Exception(
        'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})',
      );
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } on FormatException {
      // ดักจับกรณี JSON ผิดรูปแบบ
      throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}
