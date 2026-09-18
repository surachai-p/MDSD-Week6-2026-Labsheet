import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ context.watch เพื่อดึงข้อมูลมาแสดงผลและคอยอัปเดต UI อัตโนมัติเมื่อข้อมูลเปลี่ยนแปลง
    final favoritesModel = context.watch<FavoritesModel>();
    final savedItems = favoritesModel.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรด'),
        actions: [
          // ข้อกำหนด: ปุ่มต้องแสดงเฉพาะเมื่อมีรายการโปรดอย่างน้อย 1 รายการเท่านั้น
          if (savedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              onPressed: () {
                // แสดง Dialog ยืนยันก่อนล้างข้อมูลจริงด้วย showDialog และ AlertDialog
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('ยืนยันการล้างข้อมูล'),
                      content: const Text('คุณต้องการล้างรายการโปรดทั้งหมดใช่หรือไม่?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext), // ปิด Dialog
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            // ใช้ context.read เรียกใช้เมธอด clear() โดยไม่ทำให้ Widget Rebuild ซ้ำซ้อนขณะกด
                            context.read<FavoritesModel>().clear();
                            Navigator.pop(dialogContext); // ปิด Dialog หลังล้างข้อมูลเสร็จ
                          },
                          child: const Text(
                            'ล้างทั้งหมด',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: savedItems.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีรายการโปรด',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => favoritesModel.remove(item),
                  ),
                );
              },
            ),
    );
  }
}