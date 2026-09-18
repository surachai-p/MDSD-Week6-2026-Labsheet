import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ----------------------------------------------------
// Model Class: AiProduct
// ----------------------------------------------------
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
      // cast ผ่าน num แล้วเรียก .toDouble() เสมอ เพื่อป้องกันปัญหา Type Mismatch ระหว่าง int กับ double
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// ----------------------------------------------------
// API Service: AiProductService
// ----------------------------------------------------
class AiProductService {
  static const _baseUrl = 'https://fakestoreapi.com/products';

  /// ดึงรายการสินค้าทั้งหมด (Future<List<AiProduct>>)
  Future<List<AiProduct>> fetchAiProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> listJson = jsonDecode(response.body);
        return listJson
            .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})');
      }
    } on TimeoutException {
      // ดักจับกรณีการเชื่อมต่อใช้เวลานานเกิน 10 วินาที เพื่อป้องกันไม่ให้แอปค้างรอแบบไร้จุดสิ้นสุด
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // ดักจับกรณีอุปกรณ์ไม่สามารถส่ง HTTP Request ได้ เช่น ไม่มีอินเทอร์เน็ต หรือ DNS ไม่ทำงาน
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // ดักจับกรณี Response Body ไม่ใช่โครงสร้าง JSON ที่ถูกต้อง หรือโครงสร้างข้อมูลผิดปกติ
      throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง');
    } catch (e) {
      // ดักจับ Exception อื่นๆ ที่สั่ง throw ออกมา และส่งต่อให้ UI นำไปใช้งาน
      rethrow;
    }
  }

  /// ดึงรายการสินค้าชิ้นเดียวตาม ID (Future<AiProduct>)
  Future<AiProduct> fetchAiProductById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return AiProduct.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('ไม่พบข้อมูลสินค้าที่ระบุ');
      } else {
        throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})');
      }
    } on TimeoutException {
      // ดักจับกรณีร้องขอข้อมูลสินค้ารายชิ้นแล้วหมดเวลา (超過 10 วินาที)
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      // ดักจับกรณีเชื่อมต่อกับเซิร์ฟเวอร์ไม่ได้ขณะดึงข้อมูลรายสินค้า
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // ดักจับกรณีที่ JSON ของสินค้า ID นั้นๆ ไม่สามารถแปลงเป็น Model ได้
      throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง');
    } catch (e) {
      rethrow;
    }
  }
}