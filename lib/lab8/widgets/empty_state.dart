import 'package:flutter/material.dart';

/// Заглушка, когда в каталоге 0 товаров.
class EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyState({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 96, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Catalog is Empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'All products were removed.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
