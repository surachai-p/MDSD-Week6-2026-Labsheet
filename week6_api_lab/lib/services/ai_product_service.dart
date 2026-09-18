import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model สำหรับสินค้าจาก Fake Store API
/// ที่ Gemini AI Studio สร้างให้และปรับปรุงเพิ่มเติม
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
      title: json['title'] as String,
      // cast ผ่าน num ก่อนเรียก .toDouble() เสมอ เพราะ JSON ไม่แยก int/double
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }

  @override
  String toString() =>
      'AiProduct(id: $id, title: $title, price: $price, category: $category)';
}

/// ดึงรายการสินค้าทั้งหมดจาก Fake Store API
/// คืนค่าเป็น `Future<List<AiProduct>>`
/// ตั้ง timeout 10 วินาที และดักจับ exception ทุกชนิด
Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AiProduct.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('ไม่สามารถโหลดรายการสินค้าได้ (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // ดักจับกรณีเซิร์ฟเวอร์ไม่ตอบกลับภายในเวลาที่กำหนด
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับกรณีเชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย เช่น ไม่มีอินเทอร์เน็ต
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับกรณีข้อมูลที่ได้กลับมาไม่ใช่ JSON ที่ถูกต้อง
    throw Exception('รูปแบบข้อมูล JSON ที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}

/// ดึงข้อมูลสินค้ารายชิ้นตาม ID จาก Fake Store API
/// คืนค่าเป็น `Future<AiProduct>` รายการเดียว (ไม่ใช่ List)
Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return AiProduct.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      // ดักจับกรณีไม่พบสินค้าตาม ID ที่ระบุ
      throw Exception('ไม่พบสินค้า ID $id (404 Not Found)');
    }
    throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // ดักจับกรณีรอเกินเวลา 10 วินาทีที่กำหนด
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับกรณีไม่มีอินเทอร์เน็ตหรือเชื่อมต่อเซิร์ฟเวอร์ล้มเหลว
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับกรณี response ไม่ใช่ JSON ที่ parse ได้
    throw Exception('รูปแบบข้อมูล JSON ที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}
