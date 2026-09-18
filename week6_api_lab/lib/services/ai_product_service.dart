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
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AiProduct.fromJson(json)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดข้อมูลสินค้าได้ (StatusCode: ${response.statusCode})');
    }
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return AiProduct.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      throw Exception('ไม่พบข้อมูลสินค้ารหัส $id');
    } else {
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (StatusCode: ${response.statusCode})');
    }
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    throw Exception('รูปแบบข้อมูลที่ได้รับไม่ถูกต้อง');
  } catch (e) {
    rethrow;
  }
}