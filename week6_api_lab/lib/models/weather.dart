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
    // 1. ดึงค่าจาก object ย่อย 'main' โดย cast เป็น Map<String, dynamic>
    // และ cast ตัวเลขผ่าน num ก่อนเรียก .toDouble()
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 2. cast json['weather'] เป็น List<dynamic> แล้วดึงสมาชิกตัวแรกออกมาเป็น Map<String, dynamic> เพื่อดึง description
    final weatherList = json['weather'] as List<dynamic>;
    final firstWeather = weatherList.first as Map<String, dynamic>;
    final description = firstWeather['description'] as String;

    // 3. ดึง cityName จาก key 'name' ที่ระดับบนสุดของ json
    final cityName = json['name'] as String;

    // 4. return Weather(...) ครบทั้ง 4 ฟิลด์
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}
