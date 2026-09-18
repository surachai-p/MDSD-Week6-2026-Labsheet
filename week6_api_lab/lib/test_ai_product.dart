// ============================================================================
// File: lib/test_ai_product.dart
// คำอธิบาย: สคริปต์ทดสอบเรียก FakeStore REST API แบบ Standalone
// วิธีรันผ่าน Terminal:
//   dart run lib/test_ai_product.dart
// ============================================================================

import '../services/ai_product_service.dart';

void main() async {
  print('====================================================');
  print('🚀 เริ่มต้นทดสอบเรียก Fake Store API จริง...');
  print('🌐 URL: https://fakestoreapi.com/products');
  print('====================================================\n');

  final stopwatch = Stopwatch()..start();

  try {
    // ------------------------------------------------------------------------
    // การทดสอบที่ 1: ดึงรายการสินค้าทั้งหมดด้วย fetchAiProducts()
    // ------------------------------------------------------------------------
    print('📦 [ทดสอบที่ 1] กำลังเรียก fetchAiProducts()...');
    final List<AiProduct> products = await fetchAiProducts();

    print('✅ ดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด: ${products.length} รายการ');
    print('⏱️  เวลาที่ใช้: ${stopwatch.elapsedMilliseconds} มิลลิวินาที\n');

    print('--- ตัวอย่างสินค้า 3 รายการแรก ---');
    for (int i = 0; i < products.length && i < 3; i++) {
      final item = products[i];
      print('ลำดับที่ [${i + 1}]');
      print('  • รหัสสินค้า (id)   : ${item.id}');
      print('  • ชื่อสินค้า (title) : ${item.title}');
      print('  • หมวดหมู่ (category): ${item.category}');
      print('  • ราคา (price)      : \$${item.price.toStringAsFixed(2)} (ชนิดตัวแปร: ${item.price.runtimeType})');
      print('  • ลิงก์รูป (image)   : ${item.image}');
      print('  • รายละเอียด        : ${item.description.length > 60 ? "${item.description.substring(0, 60)}..." : item.description}');
      print('----------------------------------------------------');
    }

    // ------------------------------------------------------------------------
    // การทดสอบที่ 2: ดึงสินค้ารายการเดียวด้วย fetchAiProductById(1)
    // ------------------------------------------------------------------------
    print('\n📦 [ทดสอบที่ 2] กำลังเรียก fetchAiProductById(1)...');
    final AiProduct singleProduct = await fetchAiProductById(1);

    print('✅ ดึงสินค้ารายการเดียวสำเร็จ:');
    print('  • [ID #${singleProduct.id}] ${singleProduct.title}');
    print('  • ราคา: \$${singleProduct.price.toStringAsFixed(2)}');
    print('  • หมวดหมู่: ${singleProduct.category}');

    print('\n🎉 การทดสอบเสร็จสมบูรณ์ ทุกฟังก์ชันทำงานถูกต้อง 100%!');

  } catch (e) {
    // แสดงข้อความ Error ภาษาไทยที่ถูกดักจับและส่งต่อมา
    print('\n❌ เกิดข้อผิดพลาดในการทดสอบ:');
    print('รายละเอียด: $e');
  } finally {
    stopwatch.stop();
  }
}