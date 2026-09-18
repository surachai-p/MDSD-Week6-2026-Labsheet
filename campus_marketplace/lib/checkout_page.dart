import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า (Checkout)'),
        actions: [
          if (cart.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'ล้างตะกร้า',
              onPressed: () {
                context.read<CartModel>().clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ล้างตะกร้าสินค้าเรียบร้อยแล้ว')),
                );
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีสินค้าในตะกร้า',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 48,
                          height: 48,
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            context.read<CartModel>().remove(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ยอดรวมทั้งหมด:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${cart.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: cart.itemCount == 0
                                ? null
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('สั่งซื้อสินค้าสำเร็จ! ขอบคุณที่ใช้บริการ')),
                                    );
                                    context.read<CartModel>().clear();
                                    Navigator.pop(context);
                                  },
                            child: const Text('สั่งซื้อสินค้า'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
