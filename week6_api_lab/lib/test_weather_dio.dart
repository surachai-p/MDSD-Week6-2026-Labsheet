import 'services/weather_service_dio.dart';

void main() async {
  print('--- กำลังทดสอบดึงข้อมูลสภาพอากาศด้วย Dio... ---');
  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('ดึงข้อมูลสำเร็จ!\n');
    print('1. ชื่อเมือง (cityName): ${weather.cityName}');
    print('2. อุณหภูมิ (temperature): ${weather.temperature}°C');
    print('3. สภาพอากาศ (description): ${weather.description}');
  } catch (e) {
    print('Error: $e');
  }
}