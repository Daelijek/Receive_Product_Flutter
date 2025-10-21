import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';

class OrderProvider with ChangeNotifier {
  final List<List<Product>> _orderHistory = [];

  List<List<Product>> get orderHistory => _orderHistory;

  void addOrder(List<Product> items) {
    _orderHistory.add(List<Product>.from(items));
    notifyListeners();
  }

  void clearHistory() {
    _orderHistory.clear();
    notifyListeners();
  }
}