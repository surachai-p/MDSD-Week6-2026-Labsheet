import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';
import 'repositories/item_repository_api.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
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
      // ส่งผ่าน ItemRepositoryApi เข้าไปทาง Constructor ตามหลัก Dependency Injection
      home: HomePage(repository: ItemRepositoryApi()),
    );
  }
}