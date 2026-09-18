import 'package:week6_api_lab/services/weather_service.dart';

/// ทดสอบ WeatherService ผ่าน command line
/// Usage:
/// dart run lib/test_weather_service.dart              (ทดสอบ Bangkok - สำเร็จ)
/// dart run lib/test_weather_service.dart Asdfghjkl123 (ทดสอบเมืองไม่มีจริง - 404)
void main(List<String> args) async {
  final city = args.isNotEmpty ? args[0] : 'Bangkok';
  final service = WeatherService();

  print('กำลังทดสอบเมือง: $city');

  try {
    final weather = await service.fetchWeather(city);
    print('สำเร็จ!');
    print(weather);
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}