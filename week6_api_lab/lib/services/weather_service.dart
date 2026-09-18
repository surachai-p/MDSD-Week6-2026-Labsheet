import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = 'YOUR_API_KEY'; // API Key ของคุณ

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลสภาพอากาศ กรุณาตรวจสอบการสะกดชื่อเมืองอีกครั้ง');
      } else if (response.statusCode == 401) {
        throw Exception('ไม่มีสิทธิ์เข้าถึงข้อมูล กรุณาตรวจสอบ API Key');
      }
      
      throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์ (รหัส: ${response.statusCode})');
      
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณของคุณ');
    } on FormatException {
      throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}

// --- เพิ่มฟังก์ชัน main() ด้านล่างสุด เพื่อใช้รันทดสอบไฟล์นี้ ---
void main() async {
  print('กำลังเชื่อมต่อเซิร์ฟเวอร์เพื่อดึงข้อมูล...');
  final service = WeatherService();

  try {
    final weather = await service.fetchWeather('Bangkok');
    print('\n✅ ดึงข้อมูลสำเร็จ!');
    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('ความรู้สึกเหมือน: ${weather.feelsLike} °C');
    print('สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('\n❌ เกิดข้อผิดพลาด: $e');
  }
}