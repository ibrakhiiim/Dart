import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// MAIN — ChangeNotifierProvider wraps MaterialApp
// ============================================================

void main() {
  runApp(
    // Provider is ABOVE MaterialApp, so every screen (route)
    // gets the SAME CartProvider instance.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class Product {
  final int id;
  final String name;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
  });
}

const List<Product> kProducts = [
  Product(id: 1, name: 'Headphones', price: 59.99, icon: Icons.headphones),
  Product(id: 2, name: 'Smart Watch', price: 129.00, icon: Icons.watch),
  Product(id: 3, name: 'Laptop', price: 899.50, icon: Icons.laptop_mac),
  Product(id: 4, name: 'Camera', price: 349.99, icon: Icons.photo_camera),
  Product(id: 5, name: 'Keyboard', price: 45.00, icon: Icons.keyboard),
  Product(id: 6, name: 'Speaker', price: 79.90, icon: Icons.speaker),
];

// ============================================================
// PROVIDER — CartProvider extends ChangeNotifier
// ============================================================

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  /// Read-only list, so nobody can change it without notifyListeners().
  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get totalPrice => _items.fold(0.0, (sum, p) => sum + p.price);

  bool isInCart(Product product) => _items.any((p) => p.id == product.id);

  void add(Product product) {
    if (isInCart(product)) return;
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void toggle(Product product) {
    isInCart(product) ? remove(product) : add(product);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ============================================================
// WIDGET — cart icon with live badge (used on both screens)
// ============================================================

class CartBadgeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CartBadgeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // select() rebuilds this widget ONLY when count changes.
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

// ============================================================
// SCREEN 1 — Catalog
// ============================================================

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

    // read() = just call a method, no listening.
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

// ============================================================
// SCREEN 2 — Cart View
// ============================================================

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
          // List of selected products
          Expanded(
            child: cart.items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_shopping_cart_outlined, size: 64),
                        SizedBox(height: 8),
                        Text('Your cart is empty'),
                      ],
                    ),
                  )
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

          // Adding from Screen 2 — also syncs back to the catalog
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

          // Total price + Clear All
          Material(
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
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: cart.items.isEmpty
                          ? null
                          : () => _confirmClear(context),
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Clear All'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
