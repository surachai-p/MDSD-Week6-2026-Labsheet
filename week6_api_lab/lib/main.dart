import 'package:flutter/material.dart';
import 'screens/weather_search_page.dart'; // ดึงหน้าค้นหาที่เราสร้างไว้เข้ามา

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อนแถบ Debug มุมขวาบน
      title: 'Weather App',
      home: WeatherSearchPage(), // ตั้งให้หน้าแรกเป็นหน้าค้นหาสภาพอากาศ
    );
  }
}