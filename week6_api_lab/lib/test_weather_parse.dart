import 'dart:convert';
import 'models/weather.dart'; // ปรับ path ให้ตรงกับตำแหน่งไฟล์จริงในโปรเจกต์

void main() {
  // Response Body จริงที่คัดลอกมาจาก Postman ในขั้นตอนที่ 1.1
  const rawJson = '''
  {
      "coord": {
          "lon": 100.5167,
          "lat": 13.75
      },
      "weather": [
          {
              "id": 802,
              "main": "Clouds",
              "description": "เมฆกระจาย",
              "icon": "03d"
          }
      ],
      "base": "stations",
      "main": {
          "temp": 29.82,
          "feels_like": 36.32,
          "temp_min": 27.94,
          "temp_max": 30.51,
          "pressure": 1010,
          "humidity": 77,
          "sea_level": 1010,
          "grnd_level": 1009
      },
      "visibility": 10000,
      "wind": {
          "speed": 0.86,
          "deg": 139,
          "gust": 1.32
      },
      "clouds": {
          "all": 46
      },
      "dt": 1789696125,
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