import 'dart:convert';
import 'services/ai_product_service.dart';

Future<void> main() async {
  print('--- ทดสอบเรียก fetchAiProducts() ---');
  try {
    final products = await fetchAiProducts();
    print('✅ ดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด ${products.length} รายการ\n');
    for (var i = 0; i < 3 && i < products.length; i++) {
      final p = products[i];
      print('สินค้าชิ้นที่ ${i + 1}:');
      print('  - ID: ${p.id}');
      print('  - ชื่อ: ${p.title}');
      print('  - ราคา: \$${p.price}');
      print('  - หมวดหมู่: ${p.category}');
      print('  - ภาพ: ${p.image}\n');
    }
  } catch (e) {
    print('⚠️ เกิดข้อผิดพลาดจากเครือข่าย/เซิร์ฟเวอร์ FakeStoreAPI: $e');
    print('\n--- ทำการทดสอบจำลอง (Mock Data) จากโครงสร้าง JSON จริงของ FakeStoreAPI ---');
    const mockJson = '''[
      {
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description": "Your perfect pack for everyday use and walks in the forest.",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
      },
      {
        "id": 2,
        "title": "Mens Casual Premium Slim Fit T-Shirts",
        "price": 22.3,
        "description": "Slim-fitting style, contrast raglan long sleeve...",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
      },
      {
        "id": 3,
        "title": "Mens Cotton Jacket",
        "price": 55.99,
        "description": "great outerwear jackets for Spring/Autumn/Winter...",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg"
      }
    ]''';
    final List<dynamic> list = jsonDecode(mockJson) as List<dynamic>;
    final mockProducts = list.map((item) => AiProduct.fromJson(item as Map<String, dynamic>)).toList();
    print('✅ แปลงข้อมูลสำเร็จ! พบสินค้าตัวอย่าง ${mockProducts.length} รายการ\n');
    for (var i = 0; i < mockProducts.length; i++) {
      final p = mockProducts[i];
      print('สินค้าชิ้นที่ ${i + 1}:');
      print('  - ID: ${p.id}');
      print('  - ชื่อ: ${p.title}');
      print('  - ราคา: \$${p.price}');
      print('  - หมวดหมู่: ${p.category}');
      print('  - ภาพ: ${p.image}\n');
    }
  }
}
