import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  print('--- 1. ทดสอบกรณีสำเร็จ (200) ---');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature}°C');
    print('สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n--- 2. ทดสอบกรณีหาเมืองไม่พบ (404) ---');
  try {
    await service.fetchWeather('Bangkok99');
  } catch (e) {
    print('Error: $e');
  }
}