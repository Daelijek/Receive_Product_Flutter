class Product {
  final int? id; // ID из базы данных
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  int quantity;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // Конструктор из JSON (для API ответов)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '', // поддержка разных полей
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  // Конвертация в JSON (для отправки на сервер)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Старый конструктор для обратной совместимости
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product.fromJson(map);
  }
}
