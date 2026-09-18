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
    // 1. ดึงข้อมูลจาก Map ย่อย 'main' และแปลงค่าตัวเลขผ่าน num แล้วแปลงเป็น double
    final main = json['main'] as Map<String, dynamic>;
    final temperature = (main['temp'] as num).toDouble();
    final feelsLike = (main['feels_like'] as num).toDouble();

    // 2. cast json['weather'] เป็น List และดึงสมาชิกตัวแรกออกมาเป็น Map
    final weatherList = json['weather'] as List<dynamic>;
    final weatherFirst = weatherList[0] as Map<String, dynamic>;
    final description = weatherFirst['description'] as String;

    // 3. ดึงชื่อเมืองจากระดับบนสุดของ JSON
    final cityName = json['name'] as String;

    // 4. ส่งคืน Object Weather พร้อมใส่ค่าให้ครบทุกฟิลด์
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      feelsLike: feelsLike,
      );

    // TODO: ดึง feels_like จาก main ด้วยวิธีเดียวกับ temperature ด้านบน
    // TODO: cast json['weather'] เป็น List<dynamic> แล้วดึงสมาชิกตัวแรกออกมาเป็น
    //       Map<String, dynamic> เพื่อดึงค่า description
    // TODO: ดึง cityName จาก key 'name' ที่ระดับบนสุดของ json
    // TODO: return Weather(...) โดยใส่ค่าทั้ง 4 ฟิลด์ที่ดึงมาได้ให้ครบ
  }
}