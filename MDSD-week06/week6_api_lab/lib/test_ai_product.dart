import 'services/ai_product_service.dart';

void main() async {
  final service = AiProductService();

  print('=== 1. ทดสอบดึงสินค้าทั้งหมด ===');
  try {
    final products = await service.fetchAiProducts();
    print('ดึงสำเร็จ! พบสินค้าจำนวน ${products.length} รายการ:');
    for (var item in products.take(5)) { // แสดง 5 รายการแรก
      print('- [ID: ${item.id}] ${item.title} (\$${item.price})');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. ทดสอบดึงสินค้า ID: 1 ===');
  try {
    final product = await service.fetchAiProductById(1);
    print('ดึงสำเร็จ!: ${product.title} | ราคา: \$${product.price}');
  } catch (e) {
    print('Error: $e');
  }
}