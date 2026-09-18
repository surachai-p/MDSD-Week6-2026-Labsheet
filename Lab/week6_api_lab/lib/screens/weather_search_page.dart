import '../services/demo_post_service.dart';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';


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
    // ป้องกันการค้นหาถ้าช่องว่างเปล่า
    if (_cityController.text.trim().isEmpty) return;

    setState(() => _status = _ViewStatus.loading);

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      // จัดการเมื่อเกิด Error ให้แสดงหน้าจอข้อความ Error
      setState(() {
        _status = _ViewStatus.error;
        // ลบคำว่า Exception: ทิ้งเพื่อให้ผู้ใช้อ่านข้อความได้สบายตาขึ้น
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'ชื่อเมือง (เช่น Bangkok, Phuket)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
            ),
            const SizedBox(height: 16),
            
            // UI สถานะกำลังโหลด
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            
            // UI สถานะสำเร็จ
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                '${_weather!.cityName}: ${_weather!.temperature}°C',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'สภาพอากาศ: ${_weather!.description}\nรู้สึกเหมือน: ${_weather!.feelsLike}°C',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
            
            // UI สถานะ Error
            if (_status == _ViewStatus.error && _errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

            const Divider(height: 32),
                ElevatedButton(
                  onPressed: () => createDemoPost(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)', style: TextStyle(color: Colors.white)),
                ),

            const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => updateDemoPost(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)', style: TextStyle(color: Colors.white)),
                ),
          ],
        ),
      ),
    );
  }
}