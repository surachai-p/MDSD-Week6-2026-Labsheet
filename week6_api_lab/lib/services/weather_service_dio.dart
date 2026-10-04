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
        'appid': '36fee2f83d44a7228bdf36b232be78e2',
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('การรับข้อมูลจากเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        throw Exception('ไม่พบข้อมูลเมืองที่ค้นหา กรุณาตรวจสอบชื่อเมือง');
      } else if (statusCode == 401) {
        throw Exception('API Key ไม่ถูกต้องหรือไม่ได้รับอนุญาต');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัส $statusCode)');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}
