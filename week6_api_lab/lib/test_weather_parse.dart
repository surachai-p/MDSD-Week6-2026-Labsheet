import 'dart:convert';
import 'models/weather.dart';

void main() {
  // คัดลอก Response Body จริงที่ได้จาก Postman มาวางแทนที่ rawJson นี้
  const rawJson = '''
  {
    "coord": { "lon": 100.5167, "lat": 13.75 },
    "weather": [
      {
        "id": 800,
        "main": "Clear",
        "description": "ฟ้าโปร่ง",
        "icon": "01d"
      }
    ],
    "main": {
      "temp": 32.5,
      "feels_like": 36.1,
      "temp_min": 31.0,
      "temp_max": 34.0,
      "pressure": 1010,
      "humidity": 65
    },
    "name": "Bangkok"
  }
  ''';

  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final weather = Weather.fromJson(json);

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}