import 'package:flutter/material.dart';

// Категории
enum ProductCategory {
  smartphones('Smartphones', Icons.smartphone_rounded),
  tablets('Tablets', Icons.tablet_mac_rounded),
  laptops('Laptops', Icons.laptop_mac_rounded),
  audio('Audio', Icons.headphones_rounded);

  const ProductCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

// Цвет
class ProductColor {
  final String name;
  final Color color;

  const ProductColor(this.name, this.color);
}

// Память
class StorageOption {
  final String label;
  final int extraPrice;

  const StorageOption(this.label, [this.extraPrice = 0]);
}

// Характеристика
class ProductSpec {
  final IconData icon;
  final String label;
  final String value;

  const ProductSpec(this.icon, this.label, this.value);
}

// Товар
class Product {
  final String id;
  final String name;
  final String brand;
  final ProductCategory category;
  final String description;
  final String imageUrl;

  final int basePrice;
  final int? oldPrice;

  final double rating;
  final int reviewCount;
  final List<String> tags;
  final List<ProductColor> colors;
  final List<StorageOption> storageOptions;
  final List<ProductSpec> specs;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.colors,
    this.storageOptions = const [],
    required this.specs,
  });

  // Скидка
  bool get hasDiscount => oldPrice != null && oldPrice! > basePrice;

  int get discountPercent =>
      hasDiscount ? ((1 - basePrice / oldPrice!) * 100).round() : 0;

  // Цена с учётом памяти
  int priceFor(StorageOption? storage) =>
      basePrice + (storage?.extraPrice ?? 0);

  int? oldPriceFor(StorageOption? storage) =>
      hasDiscount ? oldPrice! + (storage?.extraPrice ?? 0) : null;
}
