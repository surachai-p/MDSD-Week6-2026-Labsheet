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
        'appid': 'df8caf4b7d05ad37f43f74aa50fd233d',
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    // หมดเวลาเชื่อมต่อ (ตอนเชื่อมต่อ) หรือหมดเวลารอรับข้อมูล
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    }

    // ไม่มีอินเทอร์เน็ต / เชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย
    if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    }

    // เซิร์ฟเวอร์ตอบกลับมาแต่เป็น error (เช่น 404 ไม่พบเมือง)
    if (e.response != null) {
      final statusCode = e.response!.statusCode;

      if (statusCode == 404) {
        throw Exception('ไม่พบข้อมูลสำหรับเมืองที่ระบุ');
      }

      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (สถานะ $statusCode)');
    }

    // กรณี DioException อื่น ๆ ที่ไม่เข้าเงื่อนไขข้างต้น
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  } on TypeError {
    // กรณีข้อมูลที่ได้ไม่ตรงตามรูปแบบที่ Weather.fromJson คาดหวัง
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
  }
}