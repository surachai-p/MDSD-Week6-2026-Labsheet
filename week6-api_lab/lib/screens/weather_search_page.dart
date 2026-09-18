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
        _errorMessage = e.toString();
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
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                '${_weather!.cityName}: ${_weather!.temperature}°C',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(_weather!.description),
            ],
            if (_status == _ViewStatus.error && _errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => createDemoPost(),
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => updateDemoPost(),
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
            ),
          ],
        ),
      ),
    );
  }
}