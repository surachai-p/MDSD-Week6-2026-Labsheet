import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

const _productsUrl = 'https://fakestoreapi.com/products';

Future<List<AiProduct>> fetchAiProducts() async {
  try {
    final response = await http
        .get(Uri.parse(_productsUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
        .toList();
  } on TimeoutException {
    // เกิดจาก timeout 10 วินาที ทำให้ UI ไม่ค้าง Loading เมื่อเครือข่ายช้า
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ใช้แยกปัญหา Network/Socket เช่น ปิด Wi-Fi, DNS ล้มเหลว หรือเชื่อมต่อ Server ไม่ได้
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    // เกิดเมื่อ JSON ที่ได้รับไม่สามารถ parse ได้ จึงแจ้งปัญหาข้อมูลแทนการปล่อยให้แอป Crash
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (_) {
    // Safety net สำหรับข้อผิดพลาดอื่น เช่น Type Cast หรือข้อมูลบางฟิลด์ไม่ตรง Model
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  try {
    final response = await http
        .get(Uri.parse('$_productsUrl/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'ไม่พบสินค้าหรือเซิร์ฟเวอร์ตอบกลับผิดพลาด (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AiProduct.fromJson(data);
  } on TimeoutException {
    // ป้องกัน UI ค้างรอข้อมูลสินค้ารายการนี้นานเกิน 10 วินาที
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ตรวจจับปัญหา Internet หรือการเชื่อมต่อกับ Server ไม่สำเร็จ
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    // ป้องกันกรณี Response ไม่ใช่ JSON ที่มีโครงสร้างถูกต้อง
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (_) {
    // Safety net สำหรับข้อผิดพลาดขณะ Map ค่าเข้า AiProduct.fromJson
    throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ กรุณาลองใหม่อีกครั้ง');
  }
}
