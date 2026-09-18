import 'services/ai_product_service.dart';

void main() async {
  print('กำลังดึงข้อมูลสินค้าจาก Fake Store API...');
  
  try {
    // ทดสอบดึงข้อมูลทั้งหมด
    final products = await fetchAiProducts();
    print('\n✅ ดึงข้อมูลสำเร็จ! ดึงสินค้ามาได้ทั้งหมด ${products.length} รายการ');
    
    print('\n--- ตัวอย่างสินค้า 3 รายการแรก ---');
    for (var i = 0; i < 3; i++) {
      print('${i+1}. ${products[i].title}');
      print('   หมวดหมู่: ${products[i].category} | ราคา: \$${products[i].price}\n');
    }

  } catch (e) {
    print('\n❌ เกิดข้อผิดพลาด: $e');
  }
}