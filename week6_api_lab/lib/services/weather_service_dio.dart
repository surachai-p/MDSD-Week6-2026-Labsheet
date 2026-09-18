import 'package:dio/dio.dart';

import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  try {
    // Dio แปลง JSON response.data ให้เป็น Map อัตโนมัติ
    // จึงไม่ต้องใช้ jsonDecode() เหมือนตอนใช้ http
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '5ee98622be23ba855d019ecfdd303bb0',
        'units': 'metric',
        'lang': 'th',
      },
    );

    return Weather.fromJson(
      response.data as Map<String, dynamic>,
    );
  } on DioException catch (e) {
    // กรณีเชื่อมต่อกับเซิร์ฟเวอร์ไม่สำเร็จภายในเวลาที่กำหนด
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception(
        'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง',
      );
    }

    // เซิร์ฟเวอร์ตอบกลับมาแล้ว แต่ status code ผิดพลาด
    // เช่น 404 หรือ 500
    else if (e.type == DioExceptionType.badResponse) {
      throw Exception(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})',
      );
    }

    // เชื่อมต่อกับเซิร์ฟเวอร์ได้แล้ว
    // แต่รอรับข้อมูลนานเกินกำหนด
    else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
        'รอรับข้อมูลจากเซิร์ฟเวอร์นานเกินไป กรุณาลองใหม่อีกครั้ง',
      );
    }

    // กรณีอื่น ๆ ที่ไม่ตรงกับประเภทที่กำหนดไว้
    throw Exception(
      'เกิดข้อผิดพลาด: ${e.message}',
    );
  }
}