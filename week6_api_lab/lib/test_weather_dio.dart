import 'services/weather_service_dio.dart';

Future<void> main() async {
  try {
    final weather = await fetchWeatherWithDio('Bangkok');

    print('===== Dio Weather Test =====');
    print('City Name: ${weather.cityName}');
    print('Temperature: ${weather.temperature}');
    print('Description: ${weather.description}');
    print('Feels Like: ${weather.feelsLike}');
  } catch (e) {
    print('Error: $e');
  }
}