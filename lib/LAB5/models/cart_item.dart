import 'product.dart';

// Позиция в корзине
class CartItem {
  final Product product;
  final ProductColor color;
  final StorageOption? storage;
  int quantity;

  CartItem({
    required this.product,
    required this.color,
    this.storage,
    this.quantity = 1,
  });

  int get unitPrice => product.priceFor(storage);

  int get totalPrice => unitPrice * quantity;

  String get variantLabel =>
      [color.name, if (storage != null) storage!.label].join(' · ');

  bool matches(
    Product otherProduct,
    ProductColor otherColor,
    StorageOption? otherStorage,
  ) =>
      product.id == otherProduct.id &&
      color.name == otherColor.name &&
      storage?.label == otherStorage?.label;
}
