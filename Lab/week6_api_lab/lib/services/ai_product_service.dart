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
      // แปลงตัวเลขโดย cast ผ่าน num ก่อนเรียก .toDouble() เสมอเพื่อความปลอดภัย
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// 2. ฟังก์ชันเรียก API
Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    // ตั้ง timeout ไม่เกิน 10 วินาที
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AiProduct.fromJson(json as Map<String, dynamic>)).toList();
    }
    throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้ (รหัส: ${response.statusCode})');
  } on TimeoutException {
    // ดักจับ TimeoutException: ป้องกันแอปค้างเมื่อเซิร์ฟเวอร์ตอบสนองช้ากว่าที่กำหนด
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // ดักจับ ClientException: ป้องกันแอปพังเมื่ออุปกรณ์ไม่มีอินเทอร์เน็ต หรือหาเซิร์ฟเวอร์ไม่เจอ
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // ดักจับ FormatException: ป้องกันแอปพังเมื่อข้อมูลที่เซิร์ฟเวอร์ส่งมาไม่ใช่โครงสร้าง JSON ที่ถูกต้อง
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}

// 3. ฟังก์ชันเรียก API แบบรายชิ้น (จากขั้นตอนที่ 4.2)
Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return AiProduct.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      throw Exception('ไม่พบสินค้าที่คุณค้นหา');
    }
    throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้ (รหัส: ${response.statusCode})');
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}