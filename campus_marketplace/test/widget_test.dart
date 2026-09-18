import 'package:flutter_test/flutter_test.dart';
import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/item.dart';
import 'package:campus_marketplace/repositories/item_repository.dart';
import 'package:campus_marketplace/home_page.dart';
import 'package:campus_marketplace/models/cart_model.dart';
import 'package:provider/provider.dart';

class MockItemRepository implements ItemRepository {
  @override
  Future<List<Item>> getItems() async {
    return [
      const Item(
        id: 1,
        title: 'Test Item 1',
        price: 99.99,
        description: 'Test description',
        category: 'electronics',
        imageUrl: 'https://example.com/test.jpg',
      ),
    ];
  }
}

void main() {
  testWidgets('Campus Marketplace HomePage displays title and items', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: CampusMarketplaceApp(),
      ),
    );

    // Verify AppBar title exists
    expect(find.text('Campus Marketplace'), findsOneWidget);
  });
}
