import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';
import 'repositories/item_repository_api.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    // หุ้มแอปทั้งหมดด้วย ChangeNotifierProvider เพื่อให้ทุกหน้าเรียกใช้ตะกร้า (CartModel) ได้
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Marketplace',
      theme: ThemeData(primarySwatch: Colors.blue),
      // เรียก HomePage และส่ง ItemRepositoryApi ตัวจริงเข้าไป
      home: HomePage(repository: ItemRepositoryApi()),
    );
  }
}