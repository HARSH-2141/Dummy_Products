// lib/models/cart_model.dart
import 'package:flutter/material.dart';
import 'package:dummy_page/models/product_model.dart'; // Ensure this matches your project name

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}

class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {}; // Using product ID as key

  List<CartItem> get items => _items.values.toList(); // This is the 'items' getter

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((productId, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.incrementQuantity();
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(int productId) { // This removes one quantity of the item
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.decrementQuantity();
      } else {
        _items.remove(productId); // Remove completely if quantity drops to 0
      }
      notifyListeners();
    }
  }

  void removeProductCompletely(int productId) { // This removes the entire product entry
    _items.remove(productId);
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.incrementQuantity();
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.decrementQuantity();
      } else {
        removeProductCompletely(productId); // Remove if quantity becomes 0
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}