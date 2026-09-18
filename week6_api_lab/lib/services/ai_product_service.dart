import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      title: json['title'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  try {
    final response = await http
        .get(
          Uri.parse('https://fakestoreapi.com/products'),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'ไม่สามารถโหลดรายการสินค้าได้ '
        '(HTTP ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException(
        'รูปแบบข้อมูลสินค้าจาก API ไม่ถูกต้อง',
      );
    }

    return decoded
        .map(
          (item) => AiProduct.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  } on TimeoutException {
    // เกิดจาก API ใช้เวลาตอบกลับนานเกิน 10 วินาที
    throw Exception('เชื่อมต่อ API นานเกินไป กรุณาลองใหม่');
  } on http.ClientException {
    // เกิดจากปัญหาในการเชื่อมต่อ HTTP
    throw Exception('ไม่สามารถเชื่อมต่อ Fake Store API ได้');
  } on FormatException catch (e) {
    // เกิดจากข้อมูล JSON ที่ได้รับมีรูปแบบไม่ถูกต้อง
    throw Exception('ข้อมูลจาก API ไม่ถูกต้อง: ${e.message}');
  } on SocketException {
    // เกิดจากไม่มีการเชื่อมต่อเครือข่าย
    throw Exception('ไม่พบการเชื่อมต่ออินเทอร์เน็ต');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  try {
    final response = await http
        .get(
          Uri.parse('https://fakestoreapi.com/products/$id'),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'ไม่สามารถโหลดสินค้าได้ '
        '(HTTP ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'รูปแบบข้อมูลสินค้าจาก API ไม่ถูกต้อง',
      );
    }

    return AiProduct.fromJson(decoded);
  } on TimeoutException {
    // เกิดจาก API ใช้เวลาตอบกลับนานเกิน 10 วินาที
    throw Exception('เชื่อมต่อ API นานเกินไป กรุณาลองใหม่');
  } on http.ClientException {
    // เกิดจากปัญหาในการเชื่อมต่อ HTTP
    throw Exception('ไม่สามารถเชื่อมต่อ Fake Store API ได้');
  } on FormatException catch (e) {
    // เกิดจากข้อมูล JSON ที่ได้รับมีรูปแบบไม่ถูกต้อง
    throw Exception('ข้อมูลจาก API ไม่ถูกต้อง: ${e.message}');
  } on SocketException {
    // เกิดจากไม่มีการเชื่อมต่อเครือข่าย
    throw Exception('ไม่พบการเชื่อมต่ออินเทอร์เน็ต');
  }
}