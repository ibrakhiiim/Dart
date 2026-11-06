import 'dart:math';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';

/// Главный экран: каталог в виде списка или сетки.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> _products = seedProducts();
  bool _isGrid = false; // false = список, true = сетка
  int _nextId = 11; // id для новых товаров (seed занимает 1..10)

  final Random _random = Random();

  // Шаблоны для генерации новых товаров при Pull-to-Refresh
  static const _names = ['Power Bank', 'USB-C Hub', 'Smart Lamp', 'Earbuds', 'Webcam HD', 'Fitness Band'];
  static const _categories = ['Accessories', 'Accessories', 'Smart Home', 'Audio', 'Photo', 'Wearables'];
  static const _icons = [Icons.battery_charging_full, Icons.usb, Icons.lightbulb, Icons.earbuds, Icons.videocam, Icons.fitness_center];

  // ---------------- Pull-to-Refresh ----------------

  /// Имитация сетевого запроса: ждём 1.5 сек и добавляем новый товар в начало (index 0).
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return; // экран могли закрыть во время ожидания
    setState(() {
      _products.insert(0, _generateProduct());
    });
  }

  Product _generateProduct() {
    final i = _random.nextInt(_names.length);
    final id = _nextId++;
    return Product(
      id: id,
      title: '${_names[i]} #$id',
      category: _categories[i],
      rating: double.parse((3.5 + _random.nextDouble() * 1.5).toStringAsFixed(1)),
      price: 10 + _random.nextInt(190) + 0.99,
      icon: _icons[i],
    );
  }

  // ---------------- Swipe-to-Delete + UNDO ----------------

  void _removeProduct(Product product) {
    final index = _products.indexOf(product); // запоминаем исходную позицию
    if (index == -1) return;

    setState(() {
      _products.removeAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.title} deleted'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() {
                // min() — на случай, если список стал короче, чем был index
                _products.insert(min(index, _products.length), product);
              });
            },
          ),
        ),
      );
  }

  /// Оборачивает элемент в Dismissible (используется и в списке, и в сетке).
  Widget _dismissible(Product product, Widget child) {
    return Dismissible(
      key: ValueKey(product.id), // уникальный ключ — обязателен!
      direction: DismissDirection.endToStart, // свайп справа налево
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _removeProduct(product),
      child: child,
    );
  }

  // ---------------- Empty State ----------------

  void _resetCatalog() {
    setState(() {
      _products = seedProducts();
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog'),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'List view' : 'Grid view',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: _products.isEmpty
          ? EmptyState(onReset: _resetCatalog)
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: _isGrid ? _buildGrid() : _buildList(),
            ),
    );
  }

  /// Режим 1: ListView.separated — ленивый список с разделителями.
  Widget _buildList() {
    return ListView.separated(
      // AlwaysScrollable — чтобы Pull-to-Refresh работал даже при коротком списке
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final product = _products[index];
        return _dismissible(product, ProductListTile(product: product));
      },
    );
  }

  /// Режим 2: GridView.builder — ленивая сетка в 2 колонки.
  Widget _buildGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72, // ширина / высота -> карточка выше, чем шире
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _dismissible(product, ProductGridCard(product: product));
      },
    );
  }
}
