import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/demo_post_service.dart';
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
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = 'กรุณาพิมพ์ชื่อเมือง';
      });
      return;
    }

    setState(() {
      _status = _ViewStatus.loading;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(city);
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: createDemoPost,
              child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: updateDemoPost,
              child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
            ),
            const SizedBox(height: 24),
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                _weather!.cityName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${_weather!.temperature.toStringAsFixed(2)} °C'),
              Text(_weather!.description),
              Text(
                'อุณหภูมิที่รู้สึก: '
                '${_weather!.feelsLike.toStringAsFixed(2)} °C',
              ),
            ],
            if (_status == _ViewStatus.error)
              Text(
                _errorMessage ?? 'เกิดข้อผิดพลาด',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
