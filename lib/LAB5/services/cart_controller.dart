import 'package:flutter/widgets.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

// Корзина
class CartController extends ChangeNotifier {
  static const int maxQuantityPerItem = 10;
  static const int freeDeliveryFrom = 50000;
  static const int deliveryPrice = 2000;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  // Итоги
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  int get deliveryFee =>
      subtotal == 0 || subtotal >= freeDeliveryFrom ? 0 : deliveryPrice;

  int get total => subtotal + deliveryFee;

  // Добавить товар
  void add({
    required Product product,
    required ProductColor color,
    StorageOption? storage,
    int quantity = 1,
  }) {
    final index =
        _items.indexWhere((item) => item.matches(product, color, storage));

    if (index >= 0) {
      final item = _items[index];
      item.quantity =
          (item.quantity + quantity).clamp(1, maxQuantityPerItem).toInt();
    } else {
      _items.add(CartItem(
        product: product,
        color: color,
        storage: storage,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  // Плюс
  void increment(CartItem item) {
    if (item.quantity < maxQuantityPerItem) {
      item.quantity++;
      notifyListeners();
    }
  }

  // Минус
  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  // Удалить
  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Очистить
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Доступ к корзине из любого экрана
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope not found above this widget');
    return scope!.notifier!;
  }

  static CartController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope not found above this widget');
    return scope!.notifier!;
  }
}
