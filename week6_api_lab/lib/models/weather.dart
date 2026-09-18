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
    // 1. cast json['main'] เป็น Map<String, dynamic> ก่อนดึง temp และ feels_like
    final main = json['main'] as Map<String, dynamic>;
    
    // 2. ตัวเลขทุกตัวต้อง cast ผ่าน num แล้วเรียก .toDouble() เสมอ
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 3. cast json['weather'] เป็น List<dynamic> แล้วดึงสมาชิกตัวแรกออกมาเป็น Map<String, dynamic>
    final weatherList = json['weather'] as List<dynamic>;
    final weatherItem = weatherList[0] as Map<String, dynamic>;
    final description = weatherItem['description'] as String;

    // 4. cityName ดึงจาก key name ที่ระดับบนสุดของ JSON
    final cityName = json['name'] as String;

    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}