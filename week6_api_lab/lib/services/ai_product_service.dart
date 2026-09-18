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
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

const String _baseUrl = 'https://fakestoreapi.com/products';

Future<List<AiProduct>> fetchAiProducts() async {
  final Uri uri = Uri.parse(_baseUrl);

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic decodedJson = jsonDecode(response.body);
      if (decodedJson is! List) throw const FormatException('รูปแบบไม่ถูกต้อง');

      return decodedJson
          .map((item) => AiProduct.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${response.statusCode}');
    }
  } on TimeoutException {
    throw Exception(
      'การเชื่อมต่อหมดเวลา กรุณาตรวจสอบอินเทอร์เน็ตแล้วลองใหม่อีกครั้ง',
    );
  } on http.ClientException {
    throw Exception(
      'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบสัญญาณเน็ตของคุณ',
    );
  } on FormatException {
    throw Exception('รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final Uri uri = Uri.parse('$_baseUrl/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic decodedJson = jsonDecode(response.body);
      if (decodedJson is! Map<String, dynamic>)
        throw const FormatException('รูปแบบไม่ถูกต้อง');
      return AiProduct.fromJson(decodedJson);
    } else {
      throw Exception('ไม่พบข้อมูล หรือเซิร์ฟเวอร์ผิดพลาด');
    }
  } catch (e) {
    throw Exception('เกิดข้อผิดพลาด: $e');
  }
}
