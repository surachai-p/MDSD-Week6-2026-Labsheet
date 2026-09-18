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
    // 1. แกะ object ย่อย 'main'
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 2. แกะ List 'weather' หยิบตัวแรก [0]
    final weatherList = json['weather'] as List<dynamic>;
    final firstWeather = weatherList[0] as Map<String, dynamic>;
    final description = firstWeather['description'] as String;

    // 3. แกะชื่อเมืองจากระดับบนสุด
    final cityName = json['name'] as String;

    // 4. บรรทัดสำคัญ: ต้องมี return ค่า Weather กลับออกไป
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}