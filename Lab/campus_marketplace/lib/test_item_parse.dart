import 'dart:convert';
import 'models/item.dart';

void main() {
  // ข้อมูล JSON จำลองของสินค้า 1 ชิ้นจาก Fake Store API
  const rawJson = '''
  {
    "id": 1,
    "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    "price": 109.95,
    "description": "Your perfect pack for everyday use...",
    "category": "men's clothing",
    "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
  }
  ''';

  // แปลง String เป็น Map<String, dynamic>
  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  
  // แปลง Map เป็นอ็อบเจกต์ Item
  final item = Item.fromJson(json);

  print('--- ทดสอบ Item Model ---');
  print('id: ${item.id}');
  print('title: ${item.title}');
  print('price: ${item.price}');
  print('description: ${item.description}');
  print('category: ${item.category}');
  print('imageUrl: ${item.imageUrl}');
}