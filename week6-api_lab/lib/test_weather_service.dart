import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  try {
    final weather = await service.fetchWeather('Bangkok');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}