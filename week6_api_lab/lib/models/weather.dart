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
    // 1. ดึงค่าจาก object ย่อย 'main' 
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    
    // TODO: ดึง feels_like จาก main
    final feelsLike = (main['feels_like'] as num).toDouble();

    // TODO: cast json['weather'] เป็น List<dynamic> แล้วดึงสมาชิกตัวแรก
    final weatherList = json['weather'] as List<dynamic>;
    final weatherFirstItem = weatherList[0] as Map<String, dynamic>;
    final description = weatherFirstItem['description'] as String;

    // TODO: ดึง cityName จาก key 'name'
    final cityName = json['name'] as String;

    // TODO: return Weather(...)
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}