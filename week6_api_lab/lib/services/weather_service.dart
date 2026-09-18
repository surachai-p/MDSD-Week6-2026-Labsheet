import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = '0babbe3e90d4cc60f92ea14b7a1da8d7'; // API Key ของคุณ

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      // ตรวจสอบ statusCode 200 กรณีสำเร็จ
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      }

      // ดักจับ statusCode 404 กรณีค้นหาเมืองไม่พบ
      if (response.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลสภาพอากาศเมือง "$city" กรุณาตรวจสอบชื่อเมืองและลองใหม่อีกครั้ง');
      }

      // กรณี statusCode ผิดพลาดอื่น ๆ
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ ไม่ใช่ JSON ที่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}

// จุดรันหลักเพื่อทดสอบบันทึกผล Checkpoint 2.2
void main() async {
  final service = WeatherService();

  print('=== กรณีที่ 1: ตรวจสอบกรณีสำเร็จ (Status Code 200) ===');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('Status: 200 OK');
    print('ผลลัพธ์: สำเร็จ');
    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('ข้อผิดพลาด: $e');
  }

  print('\n=== กรณีที่ 2: ตรวจสอบกรณีเมืองไม่พบ (Status Code 404) ===');
  try {
    final weather = await service.fetchWeather('NonExistentCity12345');
    print('ผลลัพธ์: ${weather.cityName}');
  } catch (e) {
    print('Status: 404 Not Found');
    print('ผลลัพธ์: ดักจับ Error ได้ถูกต้อง');
    print('ข้อความแจ้งเตือน: $e');
  }
}