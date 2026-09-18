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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _status = _ViewStatus.loading);

    try {
      // เรียก service แล้วจัดการกรณีสำเร็จ
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      // จุดที่ 1: จัดการกรณี error โดยเปลี่ยนสถานะเป็น error และดึงข้อความแจ้งเตือน
      setState(() {
        _status = _ViewStatus.error;
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
              decoration: const InputDecoration(
                labelText: 'ชื่อเมือง',
                hintText: 'เช่น Bangkok, Tokyo, London',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => createDemoPost(),
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => updateDemoPost(),
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final products = await fetchAiProducts();
                for (final p in products.take(5)) {
                  // ignore: avoid_print
                  print('[ID: ${p.id}] ${p.title} - \$${p.price}');
                }
              },
              child: const Text('ทดลอง Fake Store API (ขั้นตอนที่ 4.3)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final city = _cityController.text.trim().isEmpty ? 'Bangkok' : _cityController.text.trim();
                try {
                  final weather = await fetchWeatherWithDio(city);
                  // ignore: avoid_print
                  print('[Dio] ${weather.cityName}: ${weather.temperature}°C, ${weather.description}');
                } catch (e) {
                  // ignore: avoid_print
                  print('[Dio Error] $e');
                }
              },
              child: const Text('ทดลอง Dio (ขั้นตอนที่ 5.3)'),
            ),
            const SizedBox(height: 16),
            // สถานะที่ 1: กำลังโหลด
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            // สถานะที่ 2: สำเร็จ แสดงชื่อเมือง อุณหภูมิ และคำอธิบาย
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                '${_weather!.cityName}: ${_weather!.temperature}°C',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'รู้สึกเหมือน ${_weather!.feelsLike}°C (${_weather!.description})',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            // จุดที่ 2: สถานะที่ 3 ผิดพลาด แสดงข้อความ error เป็นตัวหนังสือสีแดง
            if (_status == _ViewStatus.error && _errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

