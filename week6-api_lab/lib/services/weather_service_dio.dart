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
      queryParameters: {'q': city, 'appid': 'YOUR_API_KEY', 'units': 'metric'},
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      // เซิร์ฟเวอร์ตอบกลับมาแล้วแต่ status code ผิดพลาด (เช่น 404, 500)
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.connectionError) {
      // ไม่สามารถสร้างการเชื่อมต่อกับเซิร์ฟเวอร์ได้เลยตั้งแต่ต้น
      // เช่น ไม่มีสัญญาณอินเทอร์เน็ต หรือ DNS หาชื่อโดเมนไม่เจอ
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}