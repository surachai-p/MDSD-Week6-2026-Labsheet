import 'services/ai_product_service.dart';

void main() async {
  print('--- กำลังดึงข้อมูลสินค้าทั้งหมดจาก Fake Store API... ---');
  try {
    final products = await fetchAiProducts();
    print('ดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด ${products.length} รายการ:\n');
    
    for (var p in products) {
      print('ID: ${p.id} | ${p.title}');
      print('หมวดหมู่: ${p.category} | ราคา: \$${p.price}');
      print('--------------------------------------------------');
    }
  } catch (e) {
    print('Error: $e');
  }
}