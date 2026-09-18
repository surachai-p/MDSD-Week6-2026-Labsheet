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
    final main = json['main'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List<dynamic>;
    final weatherData = weatherList.first as Map<String, dynamic>;

    return Weather(
      cityName: json['name'] as String,
      temperature: (main['temp'] as num).toDouble(),
      description: weatherData['description'] as String,
      feelsLike: (main['feels_like'] as num).toDouble(),
    );
  }
}
