import 'services/weather_service.dart';

Future<void> main() async {
  final service = WeatherService();

  print('=== ทดสอบกรณีสำเร็จ ===');

  try {
    final weather = await service.fetchWeather('Bangkok');

    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print(e);
  }

  print('');
  print('=== ทดสอบกรณี 404 ===');

  try {
    await service.fetchWeather(
      'CityThatDoesNotExist123456789',
    );
  } catch (e) {
    print(e);
  }
}