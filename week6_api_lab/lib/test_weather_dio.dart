import 'services/weather_service_dio.dart';

void main() async {
  print('กำลังเรียกข้อมูลสภาพอากาศด้วย Dio...');

  try {
    // ทดลองดึงข้อมูลของกรุงเทพฯ
    final weather = await fetchWeatherWithDio('Bangkok');

    print('\n ดึงข้อมูลสำเร็จ!');
    print('1. เมือง: ${weather.cityName}');
    print('2. อุณหภูมิ: ${weather.temperature} °C');
    print('3. ความรู้สึกเหมือน: ${weather.feelsLike} °C');
    print('4. สภาพอากาศ: ${weather.description}');
  } catch (e) {
    print(' เกิดข้อผิดพลาด: $e');
  }
}
