import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  if (city.trim().isEmpty) {
    throw ArgumentError('กรุณาระบุชื่อเมือง');
  }
  if (ApiConfig.openWeatherApiKey.isEmpty) {
    throw StateError(
      'ยังไม่ได้ตั้งค่า API key: รันแอปด้วย --dart-define=OPENWEATHER_API_KEY=...',
    );
  }

  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    // dio แปลง JSON response.data ให้เป็น Map ให้อัตโนมัติ ไม่ต้องเรียก jsonDecode เอง
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city.trim(),
        'appid': ApiConfig.openWeatherApiKey,
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      // กรณีเชื่อมต่อไม่ได้ภายในเวลาที่กำหนด (connectTimeout)
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      // กรณีเซิร์ฟเวอร์ตอบกลับมาแล้วแต่ status code ผิดพลาด เช่น 404, 500
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      // กรณีส่ง request ได้แต่รอรับข้อมูลนานเกินกำหนด (receiveTimeout)
      throw Exception('รอรับข้อมูลจากเซิร์ฟเวอร์นานเกินไป กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      // กรณีเชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย เช่น ไม่มีอินเทอร์เน็ต หรือ DNS ล้มเหลว
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}
