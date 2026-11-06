import 'package:flutter/material.dart';

/// Модель товара.
class Product {
  final int id; // уникальный id -> используется в ValueKey для Dismissible
  final String title;
  final String category;
  final double rating;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.price,
    required this.icon,
  });
}

/// Начальные данные каталога (seed data).
/// Используются при запуске и при нажатии "Reset Catalog".
List<Product> seedProducts() => [
      const Product(id: 1, title: 'Wireless Headphones', category: 'Audio', rating: 4.7, price: 89.99, icon: Icons.headphones),
      const Product(id: 2, title: 'Smart Watch', category: 'Wearables', rating: 4.5, price: 149.99, icon: Icons.watch),
      const Product(id: 3, title: 'Smartphone X', category: 'Phones', rating: 4.8, price: 699.00, icon: Icons.phone_iphone),
      const Product(id: 4, title: 'Laptop Pro 14', category: 'Computers', rating: 4.6, price: 1299.00, icon: Icons.laptop),
      const Product(id: 5, title: 'Mechanical Keyboard', category: 'Accessories', rating: 4.4, price: 79.50, icon: Icons.keyboard),
      const Product(id: 6, title: 'Gaming Mouse', category: 'Accessories', rating: 4.3, price: 39.99, icon: Icons.mouse),
      const Product(id: 7, title: 'Action Camera', category: 'Photo', rating: 4.2, price: 249.00, icon: Icons.camera_alt),
      const Product(id: 8, title: 'Bluetooth Speaker', category: 'Audio', rating: 4.1, price: 59.99, icon: Icons.speaker),
      const Product(id: 9, title: 'Tablet Air', category: 'Tablets', rating: 4.6, price: 499.00, icon: Icons.tablet_mac),
      const Product(id: 10, title: 'Game Controller', category: 'Gaming', rating: 4.5, price: 54.99, icon: Icons.videogame_asset),
    ];
