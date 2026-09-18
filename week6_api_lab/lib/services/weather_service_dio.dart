import 'package:dio/dio.dart';

import '../model/weather.dart';

const _apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

Future<Weather> fetchWeatherWithDio(String city) async {
  if (_apiKey.isEmpty) {
    throw Exception('ยังไม่ได้ตั้งค่า OpenWeather API Key');
  }

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': _apiKey,
        'units': 'metric',
        'lang': 'th',
      },
    );

    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      throw Exception('เซิร์ฟเวอร์ส่งข้อมูลช้าเกินไป กรุณาลองใหม่อีกครั้ง');
    } else if (error.type == DioExceptionType.connectionError) {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบเครือข่าย',
      );
    } else if (error.type == DioExceptionType.badResponse) {
      throw Exception(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด (${error.response?.statusCode})',
      );
    }

    throw Exception('เกิดข้อผิดพลาดในการเรียก API ด้วย Dio');
  } on FormatException {
    throw Exception('ข้อมูลสภาพอากาศจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}
