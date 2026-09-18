import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/demo_post_service.dart'; // เพิ่มบรรทัดนี้

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
    setState(() {
      _status = _ViewStatus.loading;
      _errorMessage = null;
    });

    try {
      final weather =
          await _weatherService.fetchWeather(_cityController.text);

      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (e) {
      setState(() {
        _status = _ViewStatus.error;

        _errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาสภาพอากาศ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'ชื่อเมือง',
                hintText: 'เช่น Bangkok',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // ปุ่มค้นหาสภาพอากาศ
ElevatedButton(
  onPressed:
      _status == _ViewStatus.loading ? null : _search,
  child: const Text('ค้นหา'),
),

const SizedBox(height: 8),

// ปุ่มทดลอง POST
ElevatedButton(
  onPressed: () => createDemoPost(),
  child: const Text('ทดลอง POST (ขั้นตอนที่ 3.1)'),
),

const SizedBox(height: 8),

// ปุ่มทดลอง PUT
ElevatedButton(
  onPressed: () => updateDemoPost(),
  child: const Text('ทดลอง PUT (ขั้นตอนที่ 3.2)'),
),

const SizedBox(height: 16),

            // สถานะกำลังโหลด
            if (_status == _ViewStatus.loading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // สถานะสำเร็จ
            if (_status == _ViewStatus.success && _weather != null) ...[
              Text(
                _weather!.cityName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${_weather!.temperature}°C',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _weather!.description,
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 4),

              Text(
                'รู้สึกเหมือน ${_weather!.feelsLike}°C',
                style: const TextStyle(fontSize: 16),
              ),
            ],

            // สถานะผิดพลาด
            if (_status == _ViewStatus.error &&
                _errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}