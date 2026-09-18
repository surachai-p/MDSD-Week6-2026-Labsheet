import 'services/weather_service_dio.dart';

void main() async {
  print('กำลังดึงข้อมูลด้วย Dio...');
  
  try {
    // ลองดึงข้อมูลของกรุงเทพฯ
    final weather = await fetchWeatherWithDio('Bangkok');
    
    print('\nดึงข้อมูลสำเร็จ! ข้อมูลที่ได้คือ:');
    print('ชื่อเมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature}°C');
    print('สภาพอากาศ: ${weather.description}');
    print('รู้สึกเหมือน: ${weather.feelsLike}°C');
    
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}