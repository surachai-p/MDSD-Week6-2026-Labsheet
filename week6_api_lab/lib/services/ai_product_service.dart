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

  AiProduct({
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
      title: json['title'] as String,
      // แปลงตัวเลขผ่าน num แล้วเรียก .toDouble() เสมอ เพื่อป้องกันข้อผิดพลาดกรณีค่าที่ส่งมาเป็น int
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    // กำหนด timeout 10 วินาที เพื่อไม่ให้แอปรอค้างถ้านานเกินไป
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AiProduct.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้ (รหัสข้อผิดพลาด: ${response.statusCode})');
    }
  } on TimeoutException {
    // จัดการข้อผิดพลาดกรณีโหลดข้อมูลนานเกินเวลาที่กำหนด (10 วินาที)
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // จัดการข้อผิดพลาดกรณีไม่มีอินเทอร์เน็ต หรือไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // จัดการข้อผิดพลาดกรณีข้อมูลที่ได้รับมาไม่ใช่รูปแบบ JSON ที่ถูกต้อง
    throw Exception('ข้อมูลที่ได้รับมาผิดรูปแบบ ไม่สามารถประมวลผลได้');
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดที่ไม่รู้จัก: $e');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    // กำหนด timeout 10 วินาที เช่นเดียวกัน
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return AiProduct.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('ไม่พบสินค้าที่ต้องการ');
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้ (รหัสข้อผิดพลาด: ${response.statusCode})');
    }
  } on TimeoutException {
    // ดัก TimeoutException เพื่อป้องกันแอปรอนานเกินไป
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดัก ClientException เพื่อแจ้งเตือนผู้ใช้เมื่อไม่มีการเชื่อมต่อเครือข่าย
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดัก FormatException เพื่อป้องกันข้อผิดพลาดกรณี API ส่งข้อมูลกลับมาผิดรูปแบบ (ไม่ใช่ JSON)
    throw Exception('ข้อมูลที่ได้รับมาผิดรูปแบบ ไม่สามารถประมวลผลได้');
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดที่ไม่รู้จัก: $e');
  }
}
