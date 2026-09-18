import 'services/ai_product_service.dart';

void main() async {
  print('--- กำลังเรียก Fake Store API ---');
  
  try {
    // ทดสอบดึงสินค้าทั้งหมด
    final products = await fetchAiProducts();
    print('✅ โหลดข้อมูลสำเร็จ! ได้รับสินค้าทั้งหมด ${products.length} รายการ');
    
    // พิมพ์ข้อมูลสินค้าทั้งหมด (เอาเงื่อนไขจำกัดแค่ 2 ชิ้นออกแล้ว)
    for (var i = 0; i < products.length; i++) {
      print('\nสินค้าชิ้นที่ ${i + 1}:');
      print('ID: ${products[i].id}');
      print('ชื่อ: ${products[i].title}');
      print('ราคา: \$${products[i].price}');
      print('หมวดหมู่: ${products[i].category}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}