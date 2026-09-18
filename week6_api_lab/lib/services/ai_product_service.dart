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
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse(
    'https://fakestoreapi.com/products',
  );

  try {
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'ไม่สามารถดึงข้อมูลสินค้าได้ รหัส ${response.statusCode}',
      );
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map(
          (json) =>
              AiProduct.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  } on TimeoutException {
    // ดักจับเมื่อ API ใช้เวลาตอบกลับนานเกิน 10 วินาที
    throw Exception(
      'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง',
    );
  } on http.ClientException {
    // ดักจับปัญหาการเชื่อมต่อ เช่น ไม่มีอินเทอร์เน็ต
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    // ดักจับกรณีข้อมูล JSON ที่ได้รับมีรูปแบบไม่ถูกต้อง
    throw Exception(
      'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง',
    );
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse(
    'https://fakestoreapi.com/products/$id',
  );

  try {
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'ไม่สามารถดึงข้อมูลสินค้าได้ รหัส ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body)
        as Map<String, dynamic>;

    return AiProduct.fromJson(json);
  } on TimeoutException {
    // ดักจับเมื่อ API ใช้เวลาตอบกลับนานเกิน 10 วินาที
    throw Exception(
      'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง',
    );
  } on http.ClientException {
    // ดักจับปัญหาการเชื่อมต่อ เช่น ไม่มีอินเทอร์เน็ต
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    // ดักจับกรณีข้อมูล JSON ที่ได้รับมีรูปแบบไม่ถูกต้อง
    throw Exception(
      'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์มีรูปแบบไม่ถูกต้อง',
    );
  }
}