import 'package:dio/dio.dart';
import 'models/weather.dart';

// ฟังก์ชันเรียก API สภาพอากาศด้วย Dio
Future<Weather> fetchWeatherWithDio(String city) async {
  final dio = Dio();
  const url = 'https://api.openweathermap.org/data/2.5/weather';
  const apiKey = '0babbe3e90d4cc60f92ea14b7a1da8d7'; // API Key ของคุณ

  try {
    // จุดสังเกตที่ 2: ส่ง queryParameters เป็น Map โดยตรง ไม่ต้องต่อ String ใน URL เอง
    final response = await dio.get(
      url,
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'th',
      },
      options: Options(receiveTimeout: const Duration(seconds: 10)),
    );

    // จุดสังเกตที่ 1: response.data เป็น Map<String, dynamic> อัตโนมัติ ไม่ต้องครอบ jsonDecode()
return Weather.fromJson(response.data);
  } on DioException catch (e) {
    // === เพิ่มเงื่อนไขตรวจสอบชนิดของ DioExceptionType ตรงนี้ ===
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('การเชื่อมต่อไปยังเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลสภาพอากาศเมือง "$city" กรุณาตรวจสอบชื่อเมือง');
      }
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      // เซิร์ฟเวอร์รับคำขอแล้วแต่ส่งข้อมูลกลับมาช้าเกินเวลาที่กำหนด
      throw Exception('เซิร์ฟเวอร์ใช้เวลาตอบกลับนานเกินไป กรุณาลองใหม่อีกครั้ง');
    } else if (e.type == DioExceptionType.connectionError) {
      // ไม่สามารถเชื่อมต่อเครือข่ายได้ เช่น อุปกรณ์ไม่ได้ต่ออินเทอร์เน็ต หรือ DNS ล้มเหลว
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
    }

    throw Exception('เกิดข้อผิดพลาดจากเครือข่าย: ${e.message}');
  }
}

void main() async {
  print('--- เริ่มทดสอบเรียก Weather API ด้วย Dio ---');
  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('1. ชื่อเมือง (cityName): ${weather.cityName}');
    print('2. อุณหภูมิ (temperature): ${weather.temperature} °C');
    print('3. รู้สึกเหมือน (feelsLike): ${weather.feelsLike} °C');
    print('4. คำอธิบายสภาพอากาศ (description): ${weather.description}');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}