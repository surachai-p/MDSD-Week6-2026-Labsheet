import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  print('=== ทดสอบกรณีสำเร็จ (Status Code: 200 OK) ===');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('ผลลัพธ์: สำเร็จ');
    print('ชื่อเมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('สภาพอากาศ: ${weather.description}');
    print('รู้สึกเหมือน: ${weather.feelsLike} °C');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }

  print('\n=== ทดสอบกรณี 404 Not Found (เมืองที่ไม่มีอยู่จริง) ===');
  try {
    final weather = await service.fetchWeather('Bangkok999999');
    print('ชื่อเมือง: ${weather.cityName}');
  } catch (e) {
    print('ผลลัพธ์: ตรวจจับข้อผิดพลาดตามเงื่อนไข (404)');
    print('ข้อความ Error: $e');
  }
}
