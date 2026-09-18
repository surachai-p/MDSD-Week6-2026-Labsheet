import 'services/ai_product_service.dart';

Future<void> main() async {
  print('=== Checkpoint 4.2: Fake Store API Products ===');

  try {
    final products = await fetchAiProducts();
    print('โหลดสินค้าสำเร็จ: ${products.length} รายการ\n');

    for (final product in products) {
      print('id: ${product.id}');
      print('title: ${product.title}');
      print('price: ${product.price}');
      print('category: ${product.category}');
      print('---');
    }

    final firstProduct = await fetchAiProductById(1);
    print('\nทดสอบเรียกสินค้ารายชิ้น (ID 1):');
    print(firstProduct);
  } catch (error) {
    print('เกิดข้อผิดพลาด: $error');
  }
}
