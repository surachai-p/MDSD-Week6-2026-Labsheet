import 'services/ai_product_service.dart';

void main() async {
  print('กำลังดึงข้อมูลสินค้าจาก API...');
  
  try {
    // ทดลองเรียกข้อมูลทั้งหมด
    final products = await fetchAiProducts();
    
    print('\nดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด ${products.length} รายการ');
    print('--- ตัวอย่างสินค้า 3 รายการแรก ---');
    
    for (int i = 0; i < 3; i++) {
      final p = products[i];
      print('${i + 1}. [${p.category}] ${p.title} (ราคา: \$${p.price})');
    }
    
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}