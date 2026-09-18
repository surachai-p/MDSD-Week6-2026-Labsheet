import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = 'YOUR_API_KEY';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      }
      if (response.statusCode == 404) {
        throw Exception('ไม่พบเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }
      throw Exception('เกิดข้อผิดพลาด ${response.statusCode} กรุณาลองใหม่อีกครั้ง');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลที่ได้รับไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
    } catch (e) {
      rethrow;
    }
  }
}