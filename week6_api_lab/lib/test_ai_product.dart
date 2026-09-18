import 'services/ai_product_service.dart';

void main() async {
  print('กำลังเรียก API ดึงข้อมูลสินค้าจาก fakestoreapi.com ...\n');

  try {
    final products = await fetchAiProducts();
    print(' สำเร็จ! ดึงข้อมูลมาได้ทั้งหมด ${products.length} ชิ้น\n');

    print('--- ตัวอย่าง 3 ชิ้นแรก ---');
    for (int i = 0; i < 3; i++) {
      print('${i + 1}. ${products[i].title}');
      print('   ราคา: \$${products[i].price}');
      print('   หมวดหมู่: ${products[i].category}\n');
    }
  } catch (e) {
    print(' Error: $e');
  }
}
