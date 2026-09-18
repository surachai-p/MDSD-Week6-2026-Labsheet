import 'package:week6_api_lab/services/ai_product_service.dart';

void main() async {
  try {
    print('กำลังโหลดข้อมูลสินค้าทั้งหมด...');
    final products = await fetchAiProducts();
    print('โหลดสินค้าสำเร็จ จำนวน: ${products.length} รายการ\n');
    
    if (products.isNotEmpty) {
      print('ตัวอย่างสินค้าชิ้นแรก:');
      print('ID: ${products[0].id}');
      print('Title: ${products[0].title}');
      print('Price: \$${products[0].price}');
      print('Category: ${products[0].category}');
      print('---');
    }

    print('\nกำลังโหลดข้อมูลสินค้า ID = 5...');
    final product = await fetchAiProductById(5);
    print('โหลดสำเร็จ:');
    print('Title: ${product.title}');
    print('Price: \$${product.price}');

  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}
