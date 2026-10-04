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
            "id": 804,
            "main": "Clouds",
            "description": "เมฆเต็มท้องฟ้า",
            "icon": "04n"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 27.8,
        "feels_like": 32.8,
        "temp_min": 26.94,
        "temp_max": 30.94,
        "pressure": 1010,
        "humidity": 88,
        "sea_level": 1010,
        "grnd_level": 1009
    },
    "visibility": 10000,
    "wind": {
        "speed": 3.37,
        "deg": 165,
        "gust": 5.01
    },
    "clouds": {
        "all": 96
    },
    "dt": 1791115176,
    "sys": {
        "type": 2,
        "id": 2112373,
        "country": "TH",
        "sunrise": 1791068843,
        "sunset": 1791111960
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
