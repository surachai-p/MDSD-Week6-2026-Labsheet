import 'package:flutter/material.dart';
import 'item.dart';

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  // ดึงรายการสินค้าในตะกร้า
  List<Item> get items => _items;
  
  // นับจำนวนชิ้นในตะกร้า
  int get itemCount => _items.length;
  
  // คำนวณราคารวม
  double get totalPrice => _items.fold(0, (total, current) => total + current.price);

  // เพิ่มสินค้าลงตะกร้า
  void add(Item item) {
    _items.add(item);
    notifyListeners(); // แจ้งเตือนให้หน้าจออัปเดตตัวเลข
  }

  // ลบสินค้าออกจากตะกร้า
  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}