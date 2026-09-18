import '../models/item.dart';

// นี่คือ Interface ที่บอกว่า "เราสามารถดึงข้อมูลสินค้าได้นะ" (แต่ไม่บอกว่าทำยังไง)
abstract class ItemRepository {
  Future<List<Item>> getItems();
}