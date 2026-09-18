class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String description;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>?;

    return Weather(
      cityName: json['name']?.toString() ?? 'Unknown',
      temperature: (main?['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main?['feels_like'] as num?)?.toDouble() ?? 0.0,
      description: weatherList != null && weatherList.isNotEmpty
          ? (weatherList[0]['description']?.toString() ?? 'Unknown')
          : 'Unknown',
    );
  }
}