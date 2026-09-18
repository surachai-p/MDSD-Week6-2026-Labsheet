import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  const AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['image'] as String,
    );
  }
}

const _productsUrl = 'https://fakestoreapi.com/products';

Future<List<AiProduct>> fetchAiProducts() async {
  try {
    final response = await http
        .get(Uri.parse(_productsUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('ไม่สามารถโหลดสินค้าได้ (สถานะ ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
        .toList();
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  try {
    final response = await http
        .get(Uri.parse('$_productsUrl/$id'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('ไม่สามารถโหลดสินค้าได้ (สถานะ ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AiProduct.fromJson(data);
  } on TimeoutException {
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
    );
  } on FormatException {
    throw Exception('ข้อมูลสินค้าจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}
