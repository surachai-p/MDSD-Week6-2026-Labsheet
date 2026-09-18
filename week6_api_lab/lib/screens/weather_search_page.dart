import 'package:flutter/material.dart';

import '../model/weather.dart';
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
  final _cityController = TextEditingController(text: 'Bangkok');

  _ViewStatus _status = _ViewStatus.idle;
  Weather? _weather;
  String? _errorMessage;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = 'กรุณาพิมพ์ชื่อเมืองก่อนค้นหา';
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
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: const InputDecoration(
                labelText: 'ชื่อเมือง',
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
              onPressed: createDemoPost,
              child: const Text('ทดลอง POST'),
            ),
            ElevatedButton(
              onPressed: updateDemoPost,
              child: const Text('ทดลอง PUT'),
            ),
            const SizedBox(height: 24),
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                _weather!.cityName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('${_weather!.temperature.toStringAsFixed(1)} °C'),
              Text('รู้สึกเหมือน ${_weather!.feelsLike.toStringAsFixed(1)} °C'),
              Text(_weather!.description),
            ],
            if (_status == _ViewStatus.error && _errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
