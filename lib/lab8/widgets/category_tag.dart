import 'package:flutter/material.dart';

/// Маленькая "плашка" с названием категории.
class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: TextStyle(fontSize: 11, color: scheme.onSecondaryContainer),
      ),
    );
  }
}
