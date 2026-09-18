import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  const apiKey = '1cdb159de4a6e62aea2625f46f5a1941';

  try {
    // Dio ดึงข้อมูลและแปลง JSON ให้เป็น Map อัตโนมัติผ่าน response.data (ไม่ต้องเรียก jsonDecode)
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
      },
    );

    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      // เซิร์ฟเวอร์ตอบกลับมาแล้วแต่ status code ผิดพลาด (เช่น 404, 500)
      if (e.response?.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลเมืองที่ค้นหา');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      // เพิ่มเติม: รอดึงข้อมูลตอบกลับจากเซิร์ฟเวอร์นานเกินเวลาที่กำหนด
      throw Exception('การรับข้อมูลจากเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      // เพิ่มเติม: ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ เช่น ไม่มีอินเทอร์เน็ต
      throw Exception('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต');
    }

    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}