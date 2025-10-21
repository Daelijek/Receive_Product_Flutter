class Product {
  final String title;
  final String description;
  final String imageUrl;
  final String price;

  Product({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
    );
  }
}
