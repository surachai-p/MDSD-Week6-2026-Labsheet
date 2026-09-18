import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/demo_post_service.dart';
import '../services/ai_product_service.dart';
import '../services/weather_service_dio.dart';

enum _ViewStatus { idle, loading, success, error }

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  State<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final _weatherService = WeatherService();
  final _cityController = TextEditingController();

  _ViewStatus _status = _ViewStatus.idle;
  Weather? _weather;
  String? _errorMessage;

  Future<void> _search() async {
    setState(() => _status = _ViewStatus.loading);

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      // จัดการ error status
      setState(() {
        _status = _ViewStatus.error;
        // ลบคำว่า Exception: ออกจากข้อความ error
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาสภาพอากาศ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'ชื่อเมือง (เช่น Bangkok)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
            ),
            const SizedBox(height: 16),
            
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
              
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                '${_weather!.cityName}: ${_weather!.temperature}°C',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(_weather!.description),
            ],
            
            // TODO (จุดที่ 2): ยังไม่มี UI สำหรับสถานะ error — เพิ่มเงื่อนไข เพื่อตรวจสอบสถานะ กรณี error 
            // ดูตัวอย่างวิธีการตรวจสอบสถานะ และการแสดงข้อความจากด้านบน โดยให้แสดงตัวหนังสือสีแดง
            if (_status == _ViewStatus.error && _errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

            const Divider(height: 32),
            const Text(
              'ส่วนทดสอบ API เพิ่มเติม (ส่วนที่ 3)',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => createDemoPost(),
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
            ),
            ElevatedButton(
              onPressed: () => updateDemoPost(),
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
            ),
            const Divider(height: 32),
            const Text(
              'ส่วนทดสอบ API ด้วย AI (ส่วนที่ 4)',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                print('กำลังโหลดข้อมูลสินค้า...');
                try {
                  final products = await fetchAiProducts();
                  print('โหลดสำเร็จ: ได้มา ${products.length} รายการ\n');
                  
                  // วนลูปปริ้นข้อมูลทั้งหมด 20 รายการ
                  for (var i = 0; i < products.length; i++) {
                    print('สินค้าที่ ${i + 1}: ${products[i].title}');
                    print('ราคา: \$${products[i].price}');
                    print('---');
                  }
                  
                } catch (e) {
                  print('เกิดข้อผิดพลาด: $e');
                }
              },
              child: const Text('ทดลอง fetchAiProducts (ขั้นตอนที่ 4.3)'),
            ),
            const Divider(height: 32),
            const Text(
              'ส่วนทดสอบ Dio (ส่วนที่ 5)',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                print('--- ทดสอบเรียก API ด้วย Dio ---');
                final city = _cityController.text.isNotEmpty ? _cityController.text : 'Bangkok';
                try {
                  final weather = await fetchWeatherWithDio(city);
                  print('เมือง: ${weather.cityName}');
                  print('อุณหภูมิ: ${weather.temperature}°C');
                  print('ความรู้สึกเหมือน: ${weather.feelsLike}°C');
                  print('สภาพอากาศ: ${weather.description}');
                } catch (e) {
                  print('เกิดข้อผิดพลาด: $e');
                }
                print('----------------------------\n');
              },
              child: const Text('ทดลอง fetchWeatherWithDio (ขั้นตอนที่ 5.3)'),
            ),
          ],
        ),
      ),
    );
  }
}
