import 'services/ai_product_service.dart';

Future<void> main() async {
  try {
    print('===== เริ่มทดสอบ Fake Store API =====');

    final products = await fetchAiProducts();

    print('เรียก API สำเร็จ!');
    print('จำนวนสินค้า: ${products.length} รายการ');

    for (final product in products) {
      print(
        'ID: ${product.id} | '
        'ชื่อ: ${product.title} | '
        'ราคา: ${product.price}',
      );
    }

    print('===== จบการทดสอบ =====');
  } catch (e) {
    print(
      'เกิดข้อผิดพลาด: '
      '${e.toString().replaceFirst('Exception: ', '')}',
    );
  }
}