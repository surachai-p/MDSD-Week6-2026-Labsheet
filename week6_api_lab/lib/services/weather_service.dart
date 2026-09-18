import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static const _apiKey = 'Your_Key';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // กรณีสำเร็จ แปลงข้อมูลด้วย Weather.fromJson
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // ดักจับกรณี 404 ไม่พบเมืองที่ค้นหา
        throw Exception('ไม่มีเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }

      // กรณี Error อื่นๆ
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } on FormatException {
      // ดักจับกรณี JSON ผิดรูปแบบ
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ');
    } catch (e) {
      rethrow;
    }
  }
}

void main() async {
  final service = WeatherService();

  print('กำลังเชื่อมต่อเซิร์ฟเวอร์เพื่อดึงข้อมูล...');
  try {
    final weather = await service.fetchWeather('Bangkok99');

    print('\n✅ ดึงข้อมูลสำเร็จ!');
    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('ความรู้สึกเหมือน: ${weather.feelsLike} °C');
    print('สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('\n❌ เกิดข้อผิดพลาด: $e');
  }
}
