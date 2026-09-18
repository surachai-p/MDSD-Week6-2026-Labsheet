import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/ai_product_service.dart';
import '../services/demo_post_service.dart';
import '../services/weather_service.dart';
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
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _status = _ViewStatus.loading;
      _errorMessage = null;
      _weather = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '');
      setState(() {
        _errorMessage = message;
        _status = _ViewStatus.error;
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
              onSubmitted: (_) =>
                  _status == _ViewStatus.loading ? null : _search(),
              decoration: const InputDecoration(
                labelText: 'ชื่อเมือง',
                hintText: 'เช่น Bangkok',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _status == _ViewStatus.loading ? null : _search,
              child: const Text('ค้นหา'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: createDemoPost,
              child: const Text('ทดลอง POST'),
            ),
            OutlinedButton(
              onPressed: updateDemoPost,
              child: const Text('ทดลอง PUT'),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  final products = await fetchAiProducts();
                  print('AI Products Count: ${products.length}');
                  for (final product in products) {
                    print(
                      'ID: ${product.id} | ${product.title} | ฿${product.price}',
                    );
                  }
                } catch (error) {
                  print('AI Products Error: $error');
                }
              },
              child: const Text('ทดลอง AI Product API'),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  final weather = await fetchWeatherWithDio(
                    _cityController.text,
                  );
                  print(
                    'Dio Weather: ${weather.cityName} | '
                    '${weather.temperature} | '
                    '${weather.description} | '
                    '${weather.feelsLike}',
                  );
                } catch (error) {
                  print('Dio Weather Error: $error');
                }
              },
              child: const Text('ทดลอง Dio Weather API'),
            ),
            const SizedBox(height: 24),
            if (_status == _ViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (_status == _ViewStatus.success && _weather != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weather!.cityName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('${_weather!.temperature.toStringAsFixed(1)}°C'),
                      Text(
                        'รู้สึกเหมือน ${_weather!.feelsLike.toStringAsFixed(1)}°C',
                      ),
                      Text(_weather!.description),
                    ],
                  ),
                ),
              ),
            if (_status == _ViewStatus.error)
              Text(
                _errorMessage ?? 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
