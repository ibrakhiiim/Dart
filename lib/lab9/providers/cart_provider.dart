import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Global cart state.
///
/// Every method that changes the cart calls [notifyListeners], so every
/// widget that listens to this provider (catalog cards, AppBar badges,
/// cart list, total price) rebuilds automatically — on any screen.
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  /// Read-only view of the cart, so nobody can change it without notifying.
  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get totalPrice => _items.fold(0.0, (sum, p) => sum + p.price);

  bool isInCart(Product product) => _items.any((p) => p.id == product.id);

  void add(Product product) {
    if (isInCart(product)) return;
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  /// Used by the "Add to Cart" toggle on the catalog screen.
  void toggle(Product product) {
    isInCart(product) ? remove(product) : add(product);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
