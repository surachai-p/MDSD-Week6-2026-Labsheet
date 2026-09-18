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
        'appid': '9ebc223ab935e004e1fb61a1885d7694',
        'units': 'metric',
        'lang': 'th',
      },
    );

    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลเมืองที่ระบุ กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      } else if (e.response?.statusCode == 401) {
        throw Exception('API Key ไม่ถูกต้อง');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('การรับข้อมูลจากเซิร์ฟเวอร์หมดเวลา');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตหรือเซิร์ฟเวอร์ได้');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}