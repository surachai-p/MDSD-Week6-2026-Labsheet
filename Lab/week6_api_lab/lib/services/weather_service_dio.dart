import 'package:dio/dio.dart';
import '../models/weather.dart';

Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    // dio จะแปลง JSON ให้เป็น Map ให้อัตโนมัติใน response.data
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      // dio สามารถส่งพารามิเตอร์ผ่าน queryParameters ได้เลย ทำให้โค้ดอ่านง่ายกว่า http
      queryParameters: {
        'q': city,
        'appid': '50554256fd9f134975254f1cca724b2a', // <-- เปลี่ยนเป็น API Key ของคุณ
        'units': 'metric',
        'lang': 'th'
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
    
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } 
    // ส่วนที่เพิ่มในขั้นตอนที่ 5.4 
    else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('เซิร์ฟเวอร์ใช้เวลาตอบกลับนานเกินไป');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาตรวจสอบอินเทอร์เน็ต');
    }
    
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}