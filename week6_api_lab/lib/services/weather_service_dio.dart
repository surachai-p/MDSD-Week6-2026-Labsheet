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
    // dio แปลง JSON response.data ให้เป็น Map ให้อัตโนมัติ ไม่ต้องเรียก jsonDecode เอง
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': city,
        'appid': '1c4628c3d8951db7c9dc77b4944b31be', // API Key
        'units': 'metric',
        'lang': 'th',
      },
    );
    return Weather.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    }
    throw Exception('เกิดข้อผิดพลาด: ${e.message}');
  }
}
