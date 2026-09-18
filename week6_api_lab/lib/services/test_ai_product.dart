import 'ai_product_service.dart';
void main() async {
  print('--- กำลังดึงรายการสินค้าจาก Fake Store API... ---');
  try {
    // 1. ทดสอบดึงรายการสินค้าทั้งหมด
    final products = await fetchAiProducts();
    print('โหลดสินค้าสำเร็จทั้งหมด: ${products.length} รายการ\n');

    for (var item in products.take(3)) {
      // แสดงตัวอย่าง 3 รายการแรก
      print('ID: ${item.id}');
      print('ชื่อ: ${item.title}');
      print('ราคา: \$${item.price}');
      print('หมวดหมู่: ${item.category}');
      print('-----------------------------');
    }

    // 2. ทดสอบดึงสินค้ารายการเดียวด้วย ID
    print('\n--- ทดสอบดึงสินค้ารายการเดียว (ID: 1) ---');
    final singleProduct = await fetchAiProductById(1);
    print('สินค้า ID 1: ${singleProduct.title} (ราคา \$${singleProduct.price})');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}