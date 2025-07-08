import 'package:flutter/material.dart';
import 'product_model.dart';

class WishlistModel extends ChangeNotifier {
  final List<Product> _wishlist = [];

  // ✅ Public getter
  List<Product> get likedProducts => _wishlist;

  // ✅ Add product
  void addProduct(Product product) {
    if (!_wishlist.contains(product)) {
      _wishlist.add(product);
      notifyListeners();
    }
  }

  // ✅ Remove product
  void removeProduct(Product product) {
    if (_wishlist.contains(product)) {
      _wishlist.remove(product);
      notifyListeners();
    }
  }

  // ✅ Toggle like
  void toggleLike(Product product) {
    if (_wishlist.contains(product)) {
      _wishlist.remove(product);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // ✅ Check if liked
  bool isLiked(Product product) => _wishlist.contains(product);
}
