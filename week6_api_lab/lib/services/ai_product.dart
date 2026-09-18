import 'dart:convert';

/// Model class สำหรับข้อมูลสินค้าจาก FakeStore API
/// ปลอดภัยจากการ parse ค่าตัวเลขด้วยการ cast ผ่าน num แล้วเรียก .toDouble()
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

  /// Factory constructor สำหรับแปลง Map<String, dynamic> เป็น AiProduct
  /// มีการตรวจสอบและแปลงค่าตัวเลขผ่าน num แล้วเรียก .toDouble() เสมอตามข้อกำหนด
  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  /// สำหรับแปลงกลับเป็น Map/JSON
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

  @override
  String toString() => 'AiProduct(id: $id, title: "$title", price: $price)';
}