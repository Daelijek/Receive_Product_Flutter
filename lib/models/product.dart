class Product {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  int quantity;

  Product({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      quantity: map['quantity'] ?? 1,
    );
  }
}
