import 'services/ai_product_service.dart';

Future<void> main() async {
  try {
    final products = await fetchAiProducts();

    print('จำนวนสินค้าทั้งหมด: ${products.length}');
    for (final product in products) {
      print('${product.id}: ${product.title} - ${product.price} USD');
    }

    final product = await fetchAiProductById(1);
    print('สินค้าตาม ID 1: ${product.title}');
  } catch (error) {
    print('เกิดข้อผิดพลาด: $error');
  }
}
