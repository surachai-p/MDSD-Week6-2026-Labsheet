import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/favorites_model.dart';
import '../models/cart_model.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesModel>();
    final cart = context.watch<CartModel>();
    final alreadySaved = favorites.items.any((i) => i.id == item.id);
    final alreadyInCart = cart.items.any((i) => i.id == item.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('\$${item.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: alreadySaved
                        ? null
                        : () {
                            context.read<FavoritesModel>().add(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('บันทึก ${item.title} ไว้ในรายการโปรดแล้ว')),
                            );
                          },
                    icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
                    label: Text(alreadySaved ? 'อยู่ในรายการโปรดแล้ว' : 'บันทึกรายการโปรด'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: alreadyInCart
                        ? null
                        : () {
                            context.read<CartModel>().add(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('เพิ่ม ${item.title} ลงตะกร้าแล้ว')),
                            );
                          },
                    icon: Icon(alreadyInCart ? Icons.check_circle : Icons.shopping_cart),
                    label: Text(alreadyInCart ? 'อยู่ในตะกร้าแล้ว' : 'เพิ่มลงตะกร้า'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
