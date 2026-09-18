import 'dart:convert';
import 'models/weather.dart'; // ปรับ path ให้ตรงกับตำแหน่งไฟล์จริงในโปรเจกต์

void main() {
  const rawJson = '''
  {
    "coord": {
      "lon": 100.5167,
      "lat": 13.75
    },
    "weather": [
      {
        "id": 500,
        "main": "Rain",
        "description": "ฝนเบา ๆ",
        "icon": "10d"
      }
    ],
    "base": "stations",
    "main": {
      "temp": 31.09,
      "feels_like": 38.09,
      "temp_min": 28.84,
      "temp_max": 32.16,
      "pressure": 1007,
      "humidity": 71,
      "sea_level": 1007,
      "grnd_level": 1006
    },
    "visibility": 10000,
    "wind": {
      "speed": 0.99,
      "deg": 264,
      "gust": 1.45
    },
    "rain": {
      "1h": 0.75
    },
    "clouds": {
      "all": 97
    },
    "dt": 1789715322,
    "sys": {
      "type": 2,
      "id": 2112373,
      "country": "TH",
      "sunrise": 1789686417,
      "sunset": 1789730264
    },
    "timezone": 25200,
    "id": 1609350,
    "name": "กรุงเทพมหานคร",
    "cod": 200
  }
  ''';

  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final weather = Weather.fromJson(json);

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}