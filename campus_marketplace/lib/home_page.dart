import 'package:provider/provider.dart';
import 'models/item.dart'; // Item model จากขั้นตอนที่ 7.2
import 'models/cart_model.dart'; // CartModel เดิมจากสัปดาห์ที่ 5
import 'repositories/item_repository.dart'; // ItemRepository (Interface) จากขั้นตอนที่ 7.3
import 'checkout_page.dart'; // CheckoutPage เดิมจากสัปดาห์ที่ 5
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ItemRepository repository;
  const HomePage({super.key, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.repository.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        // คงไอคอนตะกร้าจากสัปดาห์ที่ 5 ไว้ (ทำงานได้แล้ว ไม่ต้องแก้)
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${context.watch<CartModel>().itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CheckoutPage()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // สถานะกำลังโหลด
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // สถานะผิดพลาด
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          // สถานะสำเร็จ: แสดงรายการสินค้าด้วย ListView.builder
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('ไม่พบรายการสินค้า'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartModel>().add(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เพิ่ม "${item.title}" ลงตะกร้าแล้ว')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}