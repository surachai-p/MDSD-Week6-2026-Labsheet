import 'services/weather_service_dio.dart';

Future<void> main() async {
  print('=== ทดสอบ OpenWeather API ด้วย Dio ===');

  try {
    final weather = await fetchWeatherWithDio('Bangkok');

    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}