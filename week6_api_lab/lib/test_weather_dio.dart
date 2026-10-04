import 'services/weather_service_dio.dart';

Future<void> main() async {
  print('--- ทดสอบเรียก fetchWeatherWithDio("Bangkok") ด้วย Dio Package ---');
  try {
    final weather = await fetchWeatherWithDio('Bangkok');
    print('✅ ดึงข้อมูลสภาพอากาศสำเร็จ:');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }
}
