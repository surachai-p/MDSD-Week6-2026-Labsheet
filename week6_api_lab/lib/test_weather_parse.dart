import 'dart:convert';

import 'models/weather.dart';

void main() {
  const rawJson = '''
{
    "coord": {
        "lon": 100.5167,
        "lat": 13.75
    },
    "weather": [
        {
            "id": 501,
            "main": "Rain",
            "description": "ฝนปานกลาง",
            "icon": "10d"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 30.43,
        "feels_like": 37.43,
        "temp_min": 28.84,
        "temp_max": 31.61,
        "pressure": 1008,
        "humidity": 78,
        "sea_level": 1008,
        "grnd_level": 1007
    },
    "visibility": 10000,
    "wind": {
        "speed": 1.67,
        "deg": 264,
        "gust": 2.08
    },
    "rain": {
        "1h": 1.78
    },
    "clouds": {
        "all": 92
    },
    "dt": 1789710723,
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
