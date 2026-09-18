import 'services/weather_service_dio.dart';

void main() async {
  print('กำลังทดสอบดึงข้อมูลสภาพอากาศด้วยแพ็กเกจ Dio...');

  try {
    // เรียกใช้ฟังก์ชันดึงข้อมูลของกรุงเทพฯ ได้โดยตรงเลย
    final weather = await fetchWeatherWithDio('Bangkok'); 
    
    print('\n✅ ดึงข้อมูลสำเร็จ!');
    print('1. เมือง: ${weather.cityName}');
    print('2. อุณหภูมิ: ${weather.temperature} °C');
    print('3. ความรู้สึกเหมือน: ${weather.feelsLike} °C');
    print('4. สภาพอากาศ: ${weather.description}');
    
  } catch (e) {
    print('\n❌ เกิดข้อผิดพลาด: $e');
  }
}