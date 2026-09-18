import 'models/weather.dart';
import 'services/weather_service_dio.dart';

Future<void> main() async {
  try {
    final Weather weather = await fetchWeatherWithDio('Bangkok');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (error) {
    print('Error: $error');
  }
}
