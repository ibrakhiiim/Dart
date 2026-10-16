import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'product_image.dart';
import 'quantity_selector.dart';

// Товар в корзине
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const CartItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.read(context);
    final product = item.product;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 80,
                height: 80,
                child: ProductImage(
                  url: product.imageUrl,
                  fallbackIcon: product.category.icon,
                  tint: item.color.color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Название, вариант, цена
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.variantLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatPrice(item.totalPrice),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Кнопки плюс и минус
                      QuantitySelector(
                        compact: true,
                        quantity: item.quantity,
                        onDecrement: item.quantity > 1
                            ? () => cart.decrement(item)
                            : null,
                        onIncrement:
                            item.quantity < CartController.maxQuantityPerItem
                                ? () => cart.increment(item)
                                : null,
                      ),
                      const Spacer(),
                      // Кнопка «Удалить»
                      IconButton(
                        tooltip: 'Remove',
                        onPressed: onRemove,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.sale,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
