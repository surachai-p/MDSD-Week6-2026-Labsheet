import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

  Future<Weather> fetchWeather(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) {
      throw Exception('กรุณาระบุชื่อเมือง');
    }
    if (_apiKey.isEmpty) {
      throw Exception('ยังไม่ได้ตั้งค่า OpenWeather API Key');
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': trimmedCity,
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'th',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Weather.fromJson(json);
      }
      if (response.statusCode == 404) {
        throw Exception('ไม่พบเมืองนี้ กรุณาตรวจสอบชื่อเมือง');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})');
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      throw Exception('ข้อมูลสภาพอากาศจากเซิร์ฟเวอร์ไม่ถูกต้อง');
    }
  }
}
