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
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': 'your_api_key_here', // Replace with your actual
        'units': 'metric',
      },
    );

    // Dio แปลง JSON เป็น Map ให้แล้ว
    return Weather.fromJson(
      response.data as Map<String, dynamic>,
    );
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');

    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception(
        'เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})',
      );

    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
        'รอรับข้อมูลจากเซิร์ฟเวอร์นานเกินไป กรุณาลองใหม่อีกครั้ง',
      );
    }

    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}