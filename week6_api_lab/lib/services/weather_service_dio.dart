import 'package:dio/dio.dart';

import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final trimmedCity = city.trim();
  if (trimmedCity.isEmpty) {
    throw Exception('กรุณาระบุชื่อเมือง');
  }

  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '1807eaca8eaa9f9aabdaf4aac5c62ce0',
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(response.data as Map<String, dynamic>);
    }

    if (response.statusCode == 404) {
      throw Exception('ไม่พบเมืองนี้ กรุณาตรวจสอบชื่อเมือง');
    }

    throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})');
  } on DioException catch (error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    }

    if (error.type == DioExceptionType.connectionError) {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode ?? 0;
      if (statusCode == 404) {
        throw Exception('ไม่พบเมืองนี้ กรุณาตรวจสอบชื่อเมือง');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด ($statusCode)');
    }

    throw Exception('เกิดข้อผิดพลาดในการเรียก API');
  } on FormatException {
    throw Exception('ข้อมูลสภาพอากาศจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}
