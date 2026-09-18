class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // ดึง main เพื่อหาค่า temperature และ feelsLike
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // ดึง description จาก array weather ตัวที่ 0
    final weatherList = json['weather'] as List<dynamic>;
    final weatherObj = weatherList[0] as Map<String, dynamic>;
    final description = weatherObj['description'] as String;

    // ดึง cityName จาก name
    final cityName = json['name'] as String;

    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}
