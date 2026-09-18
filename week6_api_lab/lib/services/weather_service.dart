import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/weather.dart';

class WeatherService {
  static const _apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

  Future<Weather> fetchWeather(String city) async {
    if (_apiKey.isEmpty) {
      throw Exception('ยังไม่ได้ตั้งค่า OpenWeather API Key');
    }

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'th',
    });

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Weather.fromJson(json);
      }

      if (response.statusCode == 404) {
        throw Exception('ไม่พบเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมือง');
      }

      if (response.statusCode == 401) {
        throw Exception('API Key ไม่ถูกต้องหรือยังไม่ได้รับอนุญาต');
      }

      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลจากเซิร์ฟเวอร์ไม่อยู่ในรูปแบบที่ถูกต้อง');
    }
  }
}
