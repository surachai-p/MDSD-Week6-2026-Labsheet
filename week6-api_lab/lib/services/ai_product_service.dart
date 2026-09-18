import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ==========================================
// ส่วนที่ 1: Model class "AiProduct"
// ==========================================
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
      title: json['title'] as String? ?? '',
      // cast ตัวเลขผ่าน num ก่อนแล้วค่อยเรียก .toDouble() เสมอ
      // เพราะ JSON ไม่แยก int กับ double เคร่งครัดเหมือน Dart
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

// ==========================================
// ส่วนที่ 2: ฟังก์ชันดึงข้อมูลสินค้าทั้งหมด (List)
// ==========================================
Future<List<AiProduct>> fetchAiProducts() async {
  final url = Uri.parse('https://fakestoreapi.com/products');

  try {
    // ตั้ง timeout ไม่เกิน 10 วินาที ป้องกันแอปค้างรอไม่มีที่สิ้นสุด
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData is List) {
        return decodedData.map((item) {
          if (item is Map<String, dynamic>) {
            return AiProduct.fromJson(item);
          } else {
            throw const FormatException();
          }
        }).toList();
      } else {
        throw const FormatException();
      }
    } else {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัส ${response.statusCode})');
    }
  } on TimeoutException {
    // เกิดขึ้นเมื่อเซิร์ฟเวอร์ไม่ตอบกลับภายในเวลาที่กำหนด (10 วินาที)
    // ต้องดักแยกเพราะสาเหตุคือ "รอนานเกินไป" ไม่ใช่ "เชื่อมต่อไม่ได้เลย"
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาตรวจสอบอินเทอร์เน็ตและลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เกิดขึ้นเมื่อไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้เลยตั้งแต่ต้น
    // เช่น ไม่มีสัญญาณอินเทอร์เน็ต หรือ DNS หา host ไม่เจอ
    // ใช้ชนิดนี้แทน SocketException เพราะ SocketException มาจาก dart:io
    // ซึ่งใช้ไม่ได้เมื่อรันแอปบน Flutter Web (Chrome)
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  } on FormatException {
    // เกิดขึ้นเมื่อข้อมูลที่ตอบกลับมาไม่ใช่ JSON ที่ถูกต้อง
    // หรือโครงสร้างข้อมูลไม่ตรงกับที่โค้ดคาดไว้ (เช่น ไม่ใช่ List)
    // ต้องดักแยกเพื่อไม่ให้แอป crash ตอนพยายามแปลงข้อมูลผิดรูปแบบ
    throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง ไม่สามารถประมวลผลข้อมูลได้');
  } catch (e) {
    // ดักจับข้อผิดพลาดอื่น ๆ ที่ไม่ได้คาดการณ์ไว้ล่วงหน้า
    // เพื่อไม่ให้ error message ดิบจากระบบหลุดไปแสดงตรง ๆ กับผู้ใช้
    throw Exception('เกิดข้อผิดพลาดที่ไม่รู้จัก กรุณาลองใหม่อีกครั้ง');
  }
}

// ==========================================
// ส่วนที่ 3: ฟังก์ชันดึงข้อมูลสินค้ารายการเดียวตาม id
// ==========================================
Future<AiProduct> fetchAiProductById(int id) async {
  final url = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic>) {
        return AiProduct.fromJson(decodedData);
      } else {
        // กรณี id ไม่มีอยู่จริง fakestoreapi จะตอบกลับเป็น "null" หรือ
        // โครงสร้างที่ไม่ใช่ Map ต้องดักไว้เพื่อแปลงเป็นข้อความที่เข้าใจง่าย
        throw const FormatException();
      }
    } else {
      throw Exception('ไม่พบสินค้าที่ต้องการ (รหัส ${response.statusCode})');
    }
  } on TimeoutException {
    // เหตุผลเดียวกับ fetchAiProducts(): รอเซิร์ฟเวอร์นานเกินกำหนด
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาตรวจสอบอินเทอร์เน็ตและลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เหตุผลเดียวกับ fetchAiProducts(): เชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลย
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ');
  } on FormatException {
    // เหตุผลเดียวกับ fetchAiProducts(): ข้อมูลที่ได้ไม่ใช่ JSON ที่ถูกต้อง
    // หรือรูปร่างไม่ตรงกับที่คาดไว้ (ควรเป็น Object เดี่ยว ไม่ใช่ List)
    throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง ไม่สามารถประมวลผลข้อมูลได้');
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาดที่ไม่รู้จัก กรุณาลองใหม่อีกครั้ง');
  }
}