import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += double.parse(item.price);
    }
    return total;
  }
}
