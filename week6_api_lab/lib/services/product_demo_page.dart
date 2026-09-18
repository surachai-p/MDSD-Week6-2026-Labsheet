import 'package:flutter/material.dart';
import 'ai_product.dart';
import 'product_service.dart';

/// หน้าจอตัวอย่างแสดงการใช้งานทั้ง fetchAiProducts() และ fetchAiProductById(id)
class ProductDemoPage extends StatefulWidget {
  const ProductDemoPage({super.key});

  @override
  State<ProductDemoPage> createState() => _ProductDemoPageState();
}

class _ProductDemoPageState extends State<ProductDemoPage> {
  // ควบคุมโหมด: แสดงรายการทั้งหมด หรือดูรายตัว
  int? _selectedProductId;
  Future<List<AiProduct>>? _allProductsFuture;
  Future<AiProduct>? _singleProductFuture;

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  void _loadAllProducts() {
    setState(() {
      _selectedProductId = null;
      _allProductsFuture = fetchAiProducts();
    });
  }

  void _loadSingleProduct(int id) {
    setState(() {
      _selectedProductId = id;
      _singleProductFuture = fetchAiProductById(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedProductId == null
            ? 'รายการสินค้า (fetchAiProducts)'
            : 'สินค้ารหัส #$_selectedProductId (fetchAiProductById)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: _selectedProductId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _loadAllProducts,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_selectedProductId != null) {
                _loadSingleProduct(_selectedProductId!);
              } else {
                _loadAllProducts();
              }
            },
          ),
        ],
      ),
      body: _selectedProductId != null
          ? _buildSingleProductView()
          : _buildAllProductsView(),
    );
  }

  /// แสดงสินค้า 1 รายการจาก fetchAiProductById(id)
  Widget _buildSingleProductView() {
    return FutureBuilder<AiProduct>(
      future: _singleProductFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final errorMsg = snapshot.error.toString().replaceFirst('Exception: ', '');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
                  const SizedBox(height: 12),
                  Text(errorMsg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadSingleProduct(_selectedProductId!),
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            ),
          );
        }

        final product = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(product.image, height: 220, fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              Text(product.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('หมวดหมู่: ${product.category}', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 12),
              Text(
                '฿${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 16),
              const Text('รายละเอียดสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(product.description, style: const TextStyle(height: 1.5)),
            ],
          ),
        );
      },
    );
  }

  /// แสดงรายการสินค้าทั้งหมดจาก fetchAiProducts()
  Widget _buildAllProductsView() {
    return FutureBuilder<List<AiProduct>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final errorMsg = snapshot.error.toString().replaceFirst('Exception: ', '');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 50),
                  const SizedBox(height: 12),
                  Text(errorMsg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _loadAllProducts, child: const Text('ลองใหม่อีกครั้ง')),
                ],
              ),
            ),
          );
        }

        final products = snapshot.data ?? [];
        return ListView.separated(
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final p = products[index];
            return ListTile(
              leading: Image.network(p.image, width: 50, height: 50, fit: BoxFit.contain),
              title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('฿${p.price.toStringAsFixed(2)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _loadSingleProduct(p.id),
            );
          },
        );
      },
    );
  }
}
