import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:campus_marketplace/home_page.dart';
import 'package:campus_marketplace/models/cart_model.dart';
import 'package:campus_marketplace/models/item.dart';
import 'package:campus_marketplace/repositories/item_repository.dart';

class MockItemRepository implements ItemRepository {
  @override
  Future<List<Item>> getItems() async => [];
}

void main() {
  testWidgets('Campus Marketplace smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: MaterialApp(
          home: HomePage(repository: MockItemRepository()),
        ),
      ),
    );
    expect(find.text('Campus Marketplace'), findsOneWidget);
  });
}
