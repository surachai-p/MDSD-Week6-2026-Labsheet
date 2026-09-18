import 'dart:convert';
import 'models/weather.dart';

void main() {
  // ข้อมูลจำลอง (Mock Data) ที่หน้าตาเหมือนจาก Postman
  const rawJson = '''
  {
    "name": "Bangkok",
    "main": { "temp": 32.5, "feels_like": 36.1 },
    "weather": [ { "description": "เมฆบางส่วน" } ]
  }
  ''';

  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final weather = Weather.fromJson(json);

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}