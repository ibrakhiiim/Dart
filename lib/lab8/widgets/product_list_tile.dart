import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_tag.dart';

/// Строка товара для режима "Список".
/// Аватар-иконка, название, категория, рейтинг и цена.
class ProductListTile extends StatelessWidget {
  final Product product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        child: Icon(product.icon, color: scheme.onPrimaryContainer),
      ),
      title: Text(
        product.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            CategoryTag(category: product.category),
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 2),
            Text(product.rating.toStringAsFixed(1)),
          ],
        ),
      ),
      trailing: Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: scheme.primary,
        ),
      ),
    );
  }
}
