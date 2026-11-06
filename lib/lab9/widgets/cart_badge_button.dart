import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

/// Cart icon with a live counter badge. Used in the AppBar of both screens.
class CartBadgeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CartBadgeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // select() rebuilds this widget ONLY when the count changes.
    final count = context.select<CartProvider, int>((cart) => cart.count);

    return IconButton(
      tooltip: 'Cart',
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
