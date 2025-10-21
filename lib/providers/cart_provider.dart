import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.title == product.title);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    final index = _items.indexWhere((item) => item.title == product.title);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(Product product) {
    final index = _items.indexWhere((item) => item.title == product.title);
    if (index >= 0 && _items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int get itemCount {
    return _items.length;
  }
}
