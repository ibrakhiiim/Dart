import 'package:flutter/material.dart';

import '../screens/cart_screen.dart';
import '../services/cart_controller.dart';
import '../theme/app_theme.dart';

// Иконка корзины с бейджем
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).totalCount;

    return IconButton(
      tooltip: 'Cart',
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: AppColors.sale,
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
