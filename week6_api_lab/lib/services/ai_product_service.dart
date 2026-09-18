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
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('ข้อมูลสินค้าไม่ถูกต้อง');
      }

      return decoded
          .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('ไม่สามารถโหลดสินค้าได้ (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // TimeoutException เกิดเมื่อเซิร์ฟเวอร์ตอบช้าเกินกำหนด 10 วินาที
    // จึงต้องดักจับเพื่อให้แอปไม่ค้างและให้ผู้ใช้รู้ว่าเกิดจากการเชื่อมต่อที่ช้า
    throw Exception('การเชื่อมต่อถึงเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // http.ClientException เกิดเมื่อไม่มีอินเทอร์เน็ตหรือการเชื่อมต่อเครือข่ายผิดปกติ
    // จึงต้องดักจับเพื่อแปลงให้เข้าใจง่ายว่าเป็นปัญหาการเชื่อมต่อ ไม่ใช่แค่ข้อความระบบดิบ
    throw Exception('ไม่มีการเชื่อมต่ออินเทอร์เน็ต กรุณาตรวจสอบ Wi‑Fi หรือข้อมูลมือถือ');
  } on FormatException {
    // FormatException เกิดเมื่อ JSON ที่ได้รับจาก API ไม่ตรงรูปแบบที่คาดไว้
    // จึงต้องดักจับเพื่อแจ้งว่าข้อมูลจากเซิร์ฟเวอร์ผิดรูปแบบ ไม่ใช่ให้ผู้ใช้เห็น stack trace จากโปรแกรม
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('ข้อมูลสินค้ารายการเดียวไม่ถูกต้อง');
      }

      return AiProduct.fromJson(decoded);
    }

    throw Exception('ไม่สามารถโหลดข้อมูลสินค้ารายการนี้ได้ (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // TimeoutException ช่วยให้รู้ว่า API ตอบช้าเกินกำหนดและต้องหยุดการรอเพื่อไม่ให้แอปค้าง
    throw Exception('การเชื่อมต่อถึงเซิร์ฟเวอร์หมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // http.ClientException เป็นสัญญาณที่ชัดเจนว่าเกิดจากปัญหาความเชื่อมต่ออินเทอร์เน็ต
    // จึงควรแปลงข้อความเป็นภาษาไทยที่ใช้งานง่ายต่อผู้ใช้
    throw Exception('ไม่มีการเชื่อมต่ออินเทอร์เน็ต กรุณาตรวจสอบ Wi‑Fi หรือข้อมูลมือถือ');
  } on FormatException {
    // FormatException ต้องดักจับเพราะ JSON อาจผิดโครงสร้างหรือคืนค่าไม่เป็นรูปแบบที่คาด
    // ทำให้แอปสามารถตอบกลับด้วยข้อความภาษาไทยแทนการ crash หรือ error ที่ยากอ่าน
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}
