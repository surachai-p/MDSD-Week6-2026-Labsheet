import 'package:dio/dio.dart';

import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  const apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');
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
        'appid': apiKey,
        'units': 'metric',
        'lang': 'th',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})');
    }

    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      throw Exception('เซิร์ฟเวอร์ใช้เวลาตอบกลับนานเกินไป');
    } else if (error.type == DioExceptionType.connectionError) {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } else if (error.type == DioExceptionType.badResponse) {
      throw Exception(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด (${error.response?.statusCode})',
      );
    }

    throw Exception('เกิดข้อผิดพลาดในการเรียกข้อมูลสภาพอากาศ');
  } on FormatException {
    throw Exception('ข้อมูลสภาพอากาศจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}
