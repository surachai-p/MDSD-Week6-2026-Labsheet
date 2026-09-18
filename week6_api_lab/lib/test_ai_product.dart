import 'services/ai_product_service.dart';

Future<void> main() async {
  print('=== ทดสอบ Fake Store API ===');

  try {
    final products = await fetchAiProducts();

    print('จำนวนสินค้าที่ได้รับ: ${products.length}');
    print('');

    for (final product in products) {
      print(
        'ID: ${product.id} | '
        'ชื่อ: ${product.title} | '
        'ราคา: ${product.price}',
      );
    }
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}