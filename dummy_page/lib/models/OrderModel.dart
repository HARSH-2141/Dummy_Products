// lib/models/order_model.dart
import 'package:flutter/material.dart';
import 'product_model.dart';

class OrderModel extends ChangeNotifier {
  final List<List<Product>> _orders = [];

  List<List<Product>> get orders => _orders;

  void placeOrder(List<Product> products) {
    _orders.add(products);
    notifyListeners();
  }
}
