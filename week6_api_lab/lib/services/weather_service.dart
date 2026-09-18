import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _apiKey = 'your_api_key_here'; // Replace with your actual API key

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th',
    );

    print('กำลังเรียก API: $uri');

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final weather = Weather.fromJson(jsonDecode(response.body));

        print('เมือง: ${weather.cityName}');
        print('อุณหภูมิ: ${weather.temperature} °C');
        print('รายละเอียด: ${weather.description}');
        print('รู้สึกเหมือน: ${weather.feelsLike} °C');

        return weather;
      }

      if (response.statusCode == 404) {
        throw Exception('ไม่พบเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }

      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (${response.statusCode})');
    } on TimeoutException {
      print('ERROR: การเชื่อมต่อหมดเวลา');

      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      print('ERROR: ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');

      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } on FormatException {
      print('ERROR: JSON ที่ได้รับมีรูปแบบไม่ถูกต้อง');

      throw Exception('ข้อมูลสภาพอากาศที่ได้รับไม่ถูกต้อง');
    } catch (e) {
      print('ERROR: $e');
      rethrow;
    }
  }
}