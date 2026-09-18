// ignore_for_file: avoid_print

import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  print('========================================');
  print('ทดสอบกรณีที่ 1: ดึงข้อมูลสำเร็จ (Status 200)');
  print('========================================');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('✅ สำเร็จ!');
    print('ชื่อเมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('ความรู้สึกจริง: ${weather.feelsLike} °C');
    print('สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }

  print('\n========================================');
  print('ทดสอบกรณีที่ 2: เมืองไม่ถูกต้อง (Status 404)');
  print('========================================');
  try {
    final weather = await service.fetchWeather('UnknownCityXYZ123');
    print('ผลลัพธ์: ${weather.cityName}');
  } catch (e) {
    print('✅ ดักจับ Error ได้สำเร็จ: $e');
  }
}

