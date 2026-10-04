import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Model class ชื่อ AiProduct
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
      // Cast ตัวเลขผ่าน num แล้วเรียก .toDouble() เสมอ เพื่อความปลอดภัย
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// 2. ฟังก์ชัน fetchAiProducts() ดึงรายการสินค้าทั้งหมด
Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('เซิร์ฟเวอร์ตอบกลับด้วยรหัสข้อผิดพลาด: ${response.statusCode}');
    }
  } on TimeoutException {
    // ดักจับกรณีการเชื่อมต่อไปยังเซิร์ฟเวอร์ใช้เวลานานเกินกว่า 10 วินาที เพื่อป้องกันแอปค้างระหว่างรอ
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับกรณีปัญหาเครือข่าย เช่น อุปกรณ์ไม่ได้ต่ออินเทอร์เน็ต หรือ DNS ล้มเหลว
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับกรณีข้อมูลที่เซิร์ฟเวอร์ส่งกลับมาไม่สามารถแปลงเป็น JSON ตามรูปแบบที่ถูกต้องได้
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ');
  } catch (e) {
    rethrow;
  }
}

// 3. ฟังก์ชัน fetchAiProductById(int id) ดึงสินค้าตาม ID รายการเดียว
Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AiProduct.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('ไม่พบข้อมูลสินค้ารหัส $id');
    } else {
      throw Exception('เซิร์ฟเวอร์ตอบกลับด้วยรหัสข้อผิดพลาด: ${response.statusCode}');
    }
  } on TimeoutException {
    // ดักจับกรณีการเชื่อมต่อไปยังเซิร์ฟเวอร์เกิน 10 วินาที
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับกรณีไม่มีอินเทอร์เน็ตหรือไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับกรณีโครงสร้าง JSON ตอบกลับผิดรูปแบบ
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ');
  } catch (e) {
    rethrow;
  }
}
