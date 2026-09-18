import 'services/weather_service.dart';

Future<void> main() async {
  final service = WeatherService();

  print('กำลังดึงข้อมูลสภาพอากาศ...');
  try {
    final weather = await service.fetchWeather('Bangkok');

    print('เมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature}');
    print('สภาพอากาศ: ${weather.description}');
  } catch (error) {
    print(error);
  }
}
