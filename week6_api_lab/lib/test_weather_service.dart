import 'services/weather_service.dart';

void main() async {
  final service = WeatherService();

  print('--- ทดสอบกรณีที่ 1: สำเร็จ (ค้นหา Bangkok) ---');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('✅ สำเร็จ! ข้อมูลที่ได้:');
    print('ชื่อเมือง: ${weather.cityName}');
    print('อุณหภูมิ: ${weather.temperature}°C');
    print('คำอธิบาย: ${weather.description}');
  } catch (e) {
    print('❌ Error: $e');
  }

  print('\n--- ทดสอบกรณีที่ 2: 404 Not Found (ค้นหาเมืองที่ไม่มีจริง) ---');
  try {
    // ใส่ชื่อเมืองที่ไม่มีอยู่จริงเพื่อบังคับให้เกิด Error 404
    final weather = await service.fetchWeather('Ladkrabang1234'); 
    print('✅ สำเร็จ! ข้อมูลที่ได้: ${weather.cityName}');
  } catch (e) {
    print('❌ Error ที่ดักจับได้: $e');
  }
}