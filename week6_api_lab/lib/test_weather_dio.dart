// ignore_for_file: avoid_print

import 'services/weather_service_dio.dart';

void main() async {
  print('==============================================');
  print('ทดสอบเรียก fetchWeatherWithDio("Bangkok")');
  print('==============================================');

  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('✅ ดึงข้อมูลสภาพอากาศด้วย Dio สำเร็จ!');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }
}

