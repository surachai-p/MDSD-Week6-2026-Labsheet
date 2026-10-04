import 'services/weather_service.dart';

Future<void> main() async {
  final service = WeatherService();

  print('--- ทดสอบกรณีที่ 1: ค้นหาเมืองที่มีจริง (Bangkok) ---');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('✅ สำเร็จ (200 OK)');
    print('  - เมือง: ${weather.cityName}');
    print('  - อุณหภูมิ: ${weather.temperature} °C');
    print('  - ความรู้สึกจริง: ${weather.feelsLike} °C');
    print('  - สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }

  print('\n--- ทดสอบกรณีที่ 2: ค้นหาเมืองที่ไม่มีจริง (abcxyz) ---');
  try {
    final weather = await service.fetchWeather('abcxyz');
    print('✅ สำเร็จ: ${weather.cityName}');
  } catch (e) {
    print('✅ ดักจับ Error ได้ถูกต้อง (404 Not Found):');
    print('  - ข้อความแจ้งเตือน: $e');
  }
}
