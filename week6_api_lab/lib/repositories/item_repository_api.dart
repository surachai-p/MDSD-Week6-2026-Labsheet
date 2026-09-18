import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/item.dart';
import 'item_repository.dart';

class ItemRepositoryApi implements ItemRepository {
  static const _baseUrl = 'https://fakestoreapi.com/products';

  @override
  Future<List<Item>> getItems() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // แปลงข้อมูล List ของ JSON เป็น List<Item>
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        'ไม่สามารถโหลดรายการสินค้าได้ (สถานะ ${response.statusCode})',
      );
    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception(
        'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
      );
    } on FormatException {
      // ดักจับ FormatException กรณี JSON ผิดรูปแบบ
      throw Exception(
        'รูปแบบข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดพลาด ไม่สามารถประมวลผลได้',
      );
    } catch (e) {
      rethrow;
    }
  }
}
