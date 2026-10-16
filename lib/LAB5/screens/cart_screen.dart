import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/cart_item_tile.dart';

// Экран корзины
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Очистить корзину
  Future<void> _confirmClear(BuildContext context) async {
    final cart = CartScope.read(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.sale),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) cart.clear();
  }

  // Оформить заказ
  Future<void> _checkout(BuildContext context) async {
    final cart = CartScope.read(context);
    final total = cart.total;
    final count = cart.totalCount;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 52,
        ),
        title: const Text('Order placed!'),
        content: Text(
          'Thank you! $count item(s) for ${formatPrice(total)}.\n'
          'This is a demo — no real payment was made.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Great!'),
          ),
        ],
      ),
    );

    cart.clear();
    if (context.mounted) Navigator.of(context).pop();
  }

  // Удалить товар
  void _remove(BuildContext context, CartItem cartItem) {
    final cart = CartScope.read(context);
    cart.remove(cartItem);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${cartItem.product.name} removed')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cart.isEmpty ? 'My Cart' : 'My Cart (${cart.totalCount})',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          // Кнопка «Clear»
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context),
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.sale),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                // Удаление свайпом
                return Dismissible(
                  key: ObjectKey(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _remove(context, item),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: AppColors.sale,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                    ),
                  ),
                  child: CartItemTile(
                    item: item,
                    onRemove: () => _remove(context, item),
                  ),
                );
              },
            ),
      // Итог и Checkout
      bottomNavigationBar: cart.isEmpty
          ? null
          : _CartSummary(
              itemCount: cart.totalCount,
              subtotal: cart.subtotal,
              deliveryFee: cart.deliveryFee,
              total: cart.total,
              onCheckout: () => _checkout(context),
            ),
    );
  }
}

// Итог заказа
class _CartSummary extends StatelessWidget {
  final int itemCount;
  final int subtotal;
  final int deliveryFee;
  final int total;
  final VoidCallback onCheckout;

  const _CartSummary({
    required this.itemCount,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow(
                label: 'Subtotal ($itemCount items)',
                value: formatPrice(subtotal),
              ),
              const SizedBox(height: 6),
              _SummaryRow(
                label: 'Delivery',
                value: deliveryFee == 0 ? 'Free' : formatPrice(deliveryFee),
                valueColor: deliveryFee == 0 ? AppColors.success : null,
              ),
              const Divider(height: 24),
              _SummaryRow(
                label: 'Total',
                value: formatPrice(total),
                isBold: true,
              ),
              const SizedBox(height: 14),
              // Кнопка «Checkout»
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: onCheckout,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.lock_rounded, size: 18),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Строка итога
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: isBold ? 18 : 14,
      fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
      color: isBold ? AppColors.primary : AppColors.textSecondary,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: style.copyWith(
            color: valueColor ?? AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// Пустая корзина
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 44,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add an iPhone or Galaxy to get started',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            // Кнопка «Start shopping»
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Start shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
