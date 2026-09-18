import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = ApiConfig.openWeatherApiKey;

  Future<Weather> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      throw ArgumentError('กรุณาระบุชื่อเมือง');
    }
    if (_apiKey.isEmpty) {
      throw StateError(
        'ยังไม่ได้ตั้งค่า API key: รันแอปด้วย --dart-define=OPENWEATHER_API_KEY=...',
      );
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': city.trim(),
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'th',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      if (response.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลเมืองที่ระบุ กรุณาตรวจสอบชื่อเมืองอีกครั้ง (404)');
      }
      throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูลสภาพอากาศ (รหัส ${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('รูปแบบข้อมูล JSON ที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}
