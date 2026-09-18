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
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

// ฟังก์ชันดึงสินค้าชิ้นเดียว
Future<AiProduct> fetchAiProductById(int id) async {
  final String url = 'https://fakestoreapi.com/products/$id';

  try {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == 'null') {
        throw 'ไม่พบข้อมูลสินค้าชิ้นนี้ในระบบ';
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AiProduct.fromJson(data);
    } else {
      throw 'เซิร์ฟเวอร์ตอบกลับด้วยข้อผิดพลาด (รหัส: ${response.statusCode})';
    }
  } on TimeoutException {
    throw 'การเชื่อมต่อหมดเวลา กรุณาตรวจสอบอินเทอร์เน็ตของคุณ';
  } on http.ClientException {
    throw 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่อ';
  } on FormatException {
    throw 'รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง ไม่สามารถประมวลผลได้';
  } catch (e) {
    throw 'เกิดข้อผิดพลาดไม่คาดคิด: $e';
  }
}

// ฟังก์ชันดึงสินค้าทั้งหมด
Future<List<AiProduct>> fetchAiProducts() async {
  final String url = 'https://fakestoreapi.com/products';

  try {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => AiProduct.fromJson(item)).toList();
    } else {
      throw 'ไม่สามารถดึงรายการสินค้าได้ (รหัส: ${response.statusCode})';
    }
  } on TimeoutException {
    throw 'การเชื่อมต่อใช้เวลานานเกินไป กรุณาลองใหม่อีกครั้ง';
  } on http.ClientException {
    throw 'ไม่พบการเชื่อมต่ออินเทอร์เน็ต';
  } on FormatException {
    throw 'โครงสร้างข้อมูลจากเซิร์ฟเวอร์มีการเปลี่ยนแปลง';
  } catch (e) {
    throw 'เกิดข้อผิดพลาดในการโหลดข้อมูล: $e';
  }
}