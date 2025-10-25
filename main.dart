import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'models/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dbHelper = DatabaseHelper.instance;
  List<Product> products = [];

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final data = await dbHelper.getProducts();
    setState(() => products = data);
  }

  Future<void> _addProduct() async {
    if (nameController.text.isEmpty) return;
    final product = Product(
      name: nameController.text,
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
    );
    await dbHelper.insertProduct(product);
    nameController.clear();
    priceController.clear();
    quantityController.clear();
    _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Product Manager',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('SQLite Product Manager')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Product Name')),
                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                  TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                  ElevatedButton(onPressed: _addProduct, child: const Text('Add Product')),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ListTile(
                    title: Text('${p.name} - \$${p.price}'),
                    subtitle: Text('Quantity: ${p.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(p.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
