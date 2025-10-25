import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'database/drift_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drift Product Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final db = AppDatabase();

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drift Product Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Giá'), keyboardType: TextInputType.number),
                TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Số lượng'), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Thêm sản phẩm'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: db.watchAllProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!;
                if (products.isEmpty) {
                  return const Center(child: Text('Chưa có sản phẩm nào'));
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ListTile(
                      title: Text('${p.name}'),
                      subtitle: Text('Giá: ${p.price} | SL: ${p.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => db.deleteProduct(p.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    final name = nameCtrl.text.trim();
    final price = double.tryParse(priceCtrl.text) ?? 0.0;
    final qty = int.tryParse(qtyCtrl.text) ?? 0;

    if (name.isEmpty) return;

    db.insertProduct(ProductsCompanion.insert(
      name: name,
      price: price,
      quantity: drift.Value(qty),
    ));

    nameCtrl.clear();
    priceCtrl.clear();
    qtyCtrl.clear();
  }
}
