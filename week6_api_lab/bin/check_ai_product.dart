import 'package:week6_api_lab/services/ai_product_service.dart';

Future<void> main() async {
  try {
    final products = await fetchAiProducts();
    print('COUNT=${products.length}');
    for (final product in products.take(3)) {
      print('${product.id}: ${product.title} | ฿${product.price}');
    }
  } catch (error) {
    print('ERROR: $error');
  }
}
