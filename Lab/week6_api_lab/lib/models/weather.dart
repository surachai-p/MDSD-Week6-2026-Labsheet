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
    // 1. ดึง temp และ feels_like จาก object ย่อย 'main'
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 2. ดึง description จาก list 'weather' (ดึงสมาชิกตัวแรก index 0 ออกมาก่อน)
    final weatherList = json['weather'] as List<dynamic>;
    final weatherFirstObj = weatherList.first as Map<String, dynamic>;
    final description = weatherFirstObj['description'] as String;

    // 3. ดึง cityName จาก key 'name' ที่อยู่ระดับบนสุด
    final cityName = json['name'] as String;

    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}