import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city, 
        'appid': 'YOUR_API_KEY', 
        'units': 'metric'
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
    
  } on DioException catch (e) {
    // จัดการ Error ชนิดต่างๆ ของ Dio
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัส: ${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.connectionError) {
      // เพิ่มเงื่อนไข: กรณีไม่ได้ต่อเน็ต หรือเน็ตหลุด
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณของคุณ');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      // เพิ่มเงื่อนไข: กรณีเซิร์ฟเวอร์ใช้เวลาส่งข้อมูลกลับมานานเกินไป
      throw Exception('เซิร์ฟเวอร์ใช้เวลาส่งข้อมูลนานเกินไป กรุณาลองใหม่อีกครั้ง');
    }
    
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}