import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/demo_post_service.dart'; 

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
    FocusScope.of(context).unfocus();
    
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'ชื่อเมือง'),
              onSubmitted: (_) {
                if (_status != _ViewStatus.loading) _search();
              },
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _weather!.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            
            if (_status == _ViewStatus.error && _errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 32),
            const Divider(),
            
            // ปุ่มทดสอบ POST
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100),
              onPressed: () => createDemoPost(),
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)', style: TextStyle(color: Colors.black)),
            ),
            
            const SizedBox(height: 12),
            
            // ✅ เพิ่มปุ่มทดสอบ PUT ตรงนี้
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade100),
              onPressed: () => updateDemoPost(), // เรียกฟังก์ชัน PUT
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)', style: TextStyle(color: Colors.black)),
            ),

          ],
        ),
      ),
    );
  }
}