import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/demo_post_service.dart'; // import สำหรับปุ่มทดลอง POST และ PUT

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
      // จุดที่ 1: เพิ่ม setState จัดการกรณีค้นหาแล้วเกิด error
      setState(() {
        _status = _ViewStatus.error;
        // ลบคำว่า Exception: ออกเพื่อให้ผู้ใช้อ่านข้อความได้สบายตาขึ้น
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
              decoration: const InputDecoration(labelText: 'ชื่อเมือง'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _weather!.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
            
            // จุดที่ 2: UI สำหรับสถานะ error ให้แสดงตัวหนังสือสีแดง
            if (_status == _ViewStatus.error && _errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

            // ----------------------------------------------------
            // เพิ่มปุ่มทดลอง POST สำหรับขั้นตอนที่ 3.1 ไว้ด้านล่างสุด
            // ----------------------------------------------------
            const SizedBox(height: 32),
            const Divider(),
            ElevatedButton(
              onPressed: () => createDemoPost(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
            ),
            const SizedBox(height: 8), // ระยะห่างระหว่างปุ่ม
            // ----------------------------------------------------
            // เพิ่มปุ่มทดลอง PUT สำหรับขั้นตอนที่ 3.2 
            // ----------------------------------------------------
            ElevatedButton(
              onPressed: () => updateDemoPost(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
            ),
          ],
        ),
      ),
    );
  }
}