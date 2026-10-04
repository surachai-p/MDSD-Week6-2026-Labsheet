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
      // ลองเรียก Fake Store API ก่อนเป็นลำดับแรก (ตั้ง timeout ไว้ 3 วินาที)
      final response = await http.get(uri).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('ไม่สามารถโหลดรายการสินค้าได้ (สถานะ ${response.statusCode})');
    } catch (_) {
      // กรณีเซิร์ฟเวอร์ fakestoreapi.com มีปัญหาขัดข้อง/หมดเวลาเชื่อมต่อ (Connection Timeout)
      // ให้สำรองดึงข้อมูลจาก DummyJSON REST API อัตโนมัติ เพื่อให้แอปสามารถแสดงผลและใช้งานต่อได้
      try {
        final fallbackUri = Uri.parse('https://dummyjson.com/products?limit=10');
        final fallbackRes = await http.get(fallbackUri).timeout(const Duration(seconds: 5));
        if (fallbackRes.statusCode == 200) {
          final Map<String, dynamic> json = jsonDecode(fallbackRes.body);
          final List<dynamic> products = json['products'];
          return products.map((e) {
            return Item(
              id: e['id'] as int,
              title: e['title'] as String,
              price: (e['price'] as num).toDouble(),
              description: e['description'] as String,
              category: e['category'] as String,
              imageUrl: (e['thumbnail'] ?? '') as String,
            );
          }).toList();
        }
      } catch (_) {}

      // สำรองกรณีไม่มีอินเทอร์เน็ตเลย
      return _fallbackItems;
    }
  }

  static const List<Item> _fallbackItems = [
    Item(
      id: 1,
      title: 'Fjallraven - Foldsack No. 1 Backpack',
      price: 109.95,
      description: 'Your perfect pack for everyday use and walks in the forest.',
      category: "men's clothing",
      imageUrl: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    ),
    Item(
      id: 2,
      title: 'Mens Casual Premium Slim Fit T-Shirts',
      price: 22.3,
      description: 'Slim-fitting style, contrast raglan long sleeve...',
      category: "men's clothing",
      imageUrl: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
    ),
    Item(
      id: 3,
      title: 'Mens Cotton Jacket',
      price: 55.99,
      description: 'Great outerwear jackets for Spring/Autumn/Winter...',
      category: "men's clothing",
      imageUrl: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    ),
    Item(
      id: 4,
      title: 'Mens Casual Slim Fit',
      price: 15.99,
      description: 'The color could be slightly different between on the screen and in practice.',
      category: "men's clothing",
      imageUrl: 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
    ),
    Item(
      id: 5,
      title: 'John Hardy Women\'s Legends Naga Bracelet',
      price: 695.0,
      description: 'From our Legends Collection, inspired by the mythical water dragon...',
      category: 'jewelery',
      imageUrl: 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
    ),
  ];
}
