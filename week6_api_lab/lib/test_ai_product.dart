import 'services/ai_product_service.dart';

Future<void> main() async {
  try {
    final products = await fetchAiProducts();

    print('จำนวนสินค้า: ${products.length}');
    for (final product in products) {
      print('${product.id}: ${product.title} - ${product.price}');
    }

    final product = await fetchAiProductById(1);
    print('\nสินค้ารายชิ้น:');
    print('id: ${product.id}');
    print('title: ${product.title}');
    print('price: ${product.price}');
  } catch (error) {
    print(error);
  }
}