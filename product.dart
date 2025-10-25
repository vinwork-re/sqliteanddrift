class Product {
  final int? id;
  final String name;
  final double price;
  final int quantity;

  Product({this.id, required this.name, required this.price, required this.quantity});

  // Convert object -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  // Convert Map -> object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
