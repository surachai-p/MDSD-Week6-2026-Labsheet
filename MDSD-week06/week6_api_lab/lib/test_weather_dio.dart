import 'services/weather_service_dio.dart';

void main() async {
  print('=== ทดสอบเรียก Weather API ด้วย Dio ===');
  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('Error: $e');
  }
}