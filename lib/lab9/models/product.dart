import 'package:flutter/material.dart';

/// Simple immutable product model.
class Product {
  final int id;
  final String name;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
  });
}

/// The 6 products shown in the catalog.
const List<Product> kProducts = [
  Product(id: 1, name: 'Headphones', price: 59.99, icon: Icons.headphones),
  Product(id: 2, name: 'Smart Watch', price: 129.00, icon: Icons.watch),
  Product(id: 3, name: 'Laptop', price: 899.50, icon: Icons.laptop_mac),
  Product(id: 4, name: 'Camera', price: 349.99, icon: Icons.photo_camera),
  Product(id: 5, name: 'Keyboard', price: 45.00, icon: Icons.keyboard),
  Product(id: 6, name: 'Speaker', price: 79.90, icon: Icons.speaker),
];
