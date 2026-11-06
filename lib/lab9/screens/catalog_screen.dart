import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge_button.dart';
import 'cart_screen.dart';

/// Screen 1: catalog of 6 products with "Add to Cart" toggles.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          CartBadgeButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, index) => ProductCard(product: kProducts[index]),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Rebuilds only this card when THIS product enters/leaves the cart.
    final inCart =
        context.select<CartProvider, bool>((cart) => cart.isInCart(product));
    final colors = Theme.of(context).colorScheme;

    // read() = just call a method, no need to listen here.
    void onToggle() => context.read<CartProvider>().toggle(product);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Icon(product.icon, size: 64, color: colors.primary),
            ),
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('\$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            inCart
                ? OutlinedButton.icon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.check),
                    label: const Text('In Cart'),
                  )
                : FilledButton.icon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
          ],
        ),
      ),
    );
  }
}
