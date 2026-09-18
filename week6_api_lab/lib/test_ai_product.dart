// ignore_for_file: avoid_print

import 'services/ai_product_service.dart';

void main() async {
  print('==============================================');
  print('กำลังเรียกข้อมูลสินค้าทั้งหมดจาก Fake Store API...');
  print('==============================================');

  try {
    final products = await fetchAiProducts();
    print('✅ ดึงข้อมูลสำเร็จ! พบสินค้าทั้งหมด ${products.length} รายการ:\n');

    for (final p in products.take(5)) {
      print('📦 [ID: ${p.id}] ${p.title}');
      print('   ราคา: \$${p.price} | หมวดหมู่: ${p.category}');
      print('   รูปภาพ: ${p.image}');
      print('----------------------------------------------');
    }
    if (products.length > 5) {
      print('... และอีก ${products.length - 5} รายการ');
    }

    print('\n==============================================');
    print('ทดสอบดึงสินค้ารายการเดียวตาม ID (ID: 1):');
    print('==============================================');
    final singleProduct = await fetchAiProductById(1);
    print('✅ [ID: ${singleProduct.id}] ${singleProduct.title}');
    print('   ราคา: \$${singleProduct.price}');
    print('   รายละเอียด: ${singleProduct.description.substring(0, 50)}...');
  } catch (e) {
    print('❌ เกิดข้อผิดพลาด: $e');
  }
}

