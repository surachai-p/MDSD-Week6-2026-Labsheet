import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    // dio แปลง JSON response.data ให้เป็น Map ให้อัตโนมัติ ไม่ต้องเรียก jsonDecode เอง
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '1ce7269a22b13c6fd94601fc80354644',
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อไปยังเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('การรอรับข้อมูลจากเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตหรือเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } else if (e.type == DioExceptionType.badResponse) {
      // เซิร์ฟเวอร์ตอบกลับมาแล้วแต่ status code ผิดพลาด (เช่น 404, 500)
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัสสถานะ: ${e.response?.statusCode})');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}
