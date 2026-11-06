import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge_button.dart';

/// Screen 2: selected products, removal, total price, "Clear All".
/// Any change made here updates Screen 1 instantly (same CartProvider).
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All products will be removed from the cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<CartProvider>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch() = rebuild the whole screen on every cart change.
    final cart = context.watch<CartProvider>();
    final notInCart = kProducts.where((p) => !cart.isInCart(p)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: const [CartBadgeButton(), SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const _EmptyCart()
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final product = cart.items[index];
                      return ListTile(
                        leading: CircleAvatar(child: Icon(product.icon)),
                        title: Text(product.name),
                        subtitle:
                            Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => cart.remove(product),
                        ),
                      );
                    },
                  ),
          ),
          // Adding from Screen 2 — also syncs back to the catalog.
          if (notInCart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add more',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final p in notInCart)
                        ActionChip(
                          avatar: Icon(p.icon, size: 18),
                          label: Text(p.name),
                          onPressed: () => cart.add(p),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          _SummaryBar(
            total: cart.totalPrice,
            onClearAll:
                cart.items.isEmpty ? null : () => _confirmClear(context),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove_shopping_cart_outlined, size: 64),
          SizedBox(height: 8),
          Text('Your cart is empty'),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  final double total;
  final VoidCallback? onClearAll;

  const _SummaryBar({required this.total, required this.onClearAll});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total'),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onClearAll,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear All'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
