import 'services/weather_service_dio.dart';

void main() async {
  print('--- ทดสอบดึงข้อมูลสภาพอากาศด้วย Dio ---');
  try {
    // ทดลองดึงข้อมูลเมือง Bangkok
    final weather = await fetchWeatherWithDio('Bangkok');
    
    print('✅ สำเร็จ! ข้อมูลที่ได้คือ:');
    print('1. ชื่อเมือง (cityName): ${weather.cityName}');
    print('2. อุณหภูมิ (temperature): ${weather.temperature}°C');
    print('3. ความรู้สึกเหมือน (feelsLike): ${weather.feelsLike}°C');
    print('4. คำอธิบาย (description): ${weather.description}');
    
  } catch (e) {
    print('❌ Error: $e');
  }
}