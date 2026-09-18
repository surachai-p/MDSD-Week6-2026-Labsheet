import 'services/weather_service_dio.dart';

void main() async {
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