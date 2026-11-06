import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_tag.dart';

/// Карточка товара для режима "Сетка".
class ProductGridCard extends StatelessWidget {
  final Product product;

  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded занимает всё свободное место по высоте ->
          // карточка не переполняется (нет RenderFlex overflow).
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: scheme.primaryContainer,
              child: Icon(product.icon, size: 56, color: scheme.onPrimaryContainer),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                CategoryTag(category: product.category),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(product.rating.toStringAsFixed(1)),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
