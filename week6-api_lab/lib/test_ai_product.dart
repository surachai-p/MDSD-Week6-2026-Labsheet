import 'services/ai_product_service.dart';

void main() async {
  try {
    final products = await fetchAiProducts();
    for (final product in products) {
      print('id: ${product.id}, title: ${product.title}, price: ${product.price}');
    }
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}