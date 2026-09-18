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
    // ดึงค่าจาก object ย่อย 'main'
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();

    // 1. ดึง feels_like จาก main
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 2. Cast json['weather'] เป็น List แล้วดึงสมาชิกตัวแรกเอา description
    final weatherList = json['weather'] as List<dynamic>;
    final weatherFirst = weatherList[0] as Map<String, dynamic>;
    final description = weatherFirst['description'] as String;

    // 3. ดึง cityName จาก key 'name' ที่ระดับบนสุด
    final cityName = json['name'] as String;

    // 4. Return Weather Instance พร้อมใส่ค่าครบทั้ง 4 ฟิลด์
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
    );
  }
}
