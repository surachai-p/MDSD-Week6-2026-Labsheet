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
      // cast ตัวเลขผ่าน num แล้วเรียก .toDouble() เสมอตามข้อกำหนด
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// 2. ฟังก์ชัน fetchAiProducts() ดึงข้อมูลสินค้าทั้งหมด
Future<List<AiProduct>> fetchAiProducts() async {
  try {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AiProduct.fromJson(json)).toList();
    }
    throw Exception('โหลดข้อมูลไม่สำเร็จ (รหัส: ${response.statusCode})');
  } on TimeoutException {
    // ดักจับ TimeoutException: ป้องกันแอปค้างเมื่อเซิร์ฟเวอร์ตอบสนองช้า หรืออินเทอร์เน็ตผู้ใช้ช้ามาก
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับ ClientException: แจ้งเตือนเมื่อไม่สามารถเชื่อมต่อเครือข่ายได้เลย (เช่น ไม่มีอินเทอร์เน็ต)
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับ FormatException: ป้องกันกรณีเซิร์ฟเวอร์ตอบกลับมาเป็น HTML หรือข้อมูลที่ไม่ใช่ JSON
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}

// 3. ฟังก์ชัน fetchAiProductById(int id) ดึงข้อมูลสินค้าชิ้นเดียว
Future<AiProduct> fetchAiProductById(int id) async {
  try {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return AiProduct.fromJson(jsonDecode(response.body));
    }
    throw Exception('ไม่พบข้อมูลสินค้ารหัส $id');
  } on TimeoutException {
    // ดักจับ TimeoutException: ป้องกันแอปค้างเมื่อเซิร์ฟเวอร์ตอบสนองช้า
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับ ClientException: แจ้งเตือนเมื่อไม่สามารถเชื่อมต่อเครือข่ายได้เลย
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับ FormatException: ป้องกันกรณีเซิร์ฟเวอร์ส่งข้อมูลมาผิดรูปแบบ
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}