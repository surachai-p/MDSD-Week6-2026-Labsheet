import 'models/weather.dart';
import 'services/weather_service.dart';

Future<void> main() async {
  final weatherService = WeatherService();

  print('=== ทดสอบกรณีสำเร็จ (Status Code: 200 OK) ===');
  try {
    final Weather weather = await weatherService.fetchWeather('Bangkok');
    print('ผลลัพธ์: สำเร็จ');
    print('ชื่อเมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature} °C');
    print('สภาพอากาศ: ${weather.description}');
    print('รู้สึกเหมือน: ${weather.feelsLike} °C');
  } catch (error) {
    print('ผลลัพธ์: ไม่สำเร็จ');
    print('ข้อความ Error: $error');
  }

  print('');
  print('=== ทดสอบกรณี 404 Not Found (เมืองที่ไม่มีอยู่จริง) ===');
  try {
    await weatherService.fetchWeather('NonExistentCityXYZ999');
    print('ผลลัพธ์: ไม่ถูกต้อง — ควรได้รับ 404');
  } catch (error) {
    print('ผลลัพธ์: ตรวจจับข้อผิดพลาดตามเงื่อนไข (404)');
    print('ข้อความ Error: $error');
  }
}
