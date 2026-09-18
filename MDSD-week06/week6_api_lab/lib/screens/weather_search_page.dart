import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/demo_post_service.dart';
import '../services/ai_product_service.dart';
import '../services/weather_service_dio.dart'; // import เพิ่มสำหรับขั้นตอนที่ 5.3

enum _ViewStatus { idle, loading, success, error }

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  State<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  final _weatherService = WeatherService();
  final _aiProductService = AiProductService();
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
      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาสภาพอากาศ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'ชื่อเมือง'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _status == _ViewStatus.loading ? null : _search,
                child: const Text('ค้นหา'),
              ),
              const SizedBox(height: 8),

              // ปุ่มทดลอง POST (ขั้นตอนที่ 3.1)
              ElevatedButton(
                onPressed: () => createDemoPost(),
                child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
              ),
              const SizedBox(height: 8),

              // ปุ่มทดลอง PUT (ขั้นตอนที่ 3.2)
              ElevatedButton(
                onPressed: () => updateDemoPost(),
                child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
              ),
              const SizedBox(height: 8),

              // ปุ่มทดลอง Fake Store API (ขั้นตอนที่ 4.3)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade50,
                ),
                onPressed: () async {
                  try {
                    final products = await _aiProductService.fetchAiProducts();
                    print('=== รายการสินค้าจาก Fake Store API (${products.length} รายการ) ===');
                    for (var item in products.take(5)) {
                      print('- [ID: ${item.id}] ${item.title} (\$${item.price})');
                    }
                  } catch (e) {
                    print('Error FakeStore: $e');
                  }
                },
                child: const Text('ทดลอง Fake Store API (ขั้นตอนที่ 4.3)'),
              ),
              const SizedBox(height: 8),

              // ปุ่มทดลอง Dio (ขั้นตอนที่ 5.3)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade50,
                ),
                onPressed: () async {
                  try {
                    final city = _cityController.text.isEmpty
                        ? 'Bangkok'
                        : _cityController.text;
                    final weather = await fetchWeatherWithDio(city);
                    print('=== [Dio Success] ===');
                    print('เมือง: ${weather.cityName}');
                    print('อุณหภูมิ: ${weather.temperature}°C');
                    print('สภาพอากาศ: ${weather.description}');
                    print('รู้สึกเหมือน: ${weather.feelsLike}°C');
                  } catch (e) {
                    print('Error Dio: $e');
                  }
                },
                child: const Text('ทดลอง Dio (ขั้นตอนที่ 5.3)'),
              ),

              const SizedBox(height: 16),
              // สถานะกำลังโหลด 
              if (_status == _ViewStatus.loading)
                const Center(child: CircularProgressIndicator()),
              // สถานะสำเร็จ 
              if (_status == _ViewStatus.success && _weather != null) ...[
                Text(
                  '${_weather!.cityName}: ${_weather!.temperature}°C',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(_weather!.description),
              ],
              // สถานะ Error
              if (_status == _ViewStatus.error && _errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}