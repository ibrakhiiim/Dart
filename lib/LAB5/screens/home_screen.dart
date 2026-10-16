import 'package:flutter/material.dart';

import '../data/mock_products.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

// Главный экран
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductCategory? _selectedCategory;
  String _selectedBrand = kBrands.first;
  String _searchQuery = '';
  bool _showOnlyFavorites = false;
  final Set<String> _favoriteIds = {};

  // Фильтрация товаров
  List<Product> get _visibleProducts {
    final query = _searchQuery.trim().toLowerCase();

    return kMockProducts.where((p) {
      final matchesCategory =
          _selectedCategory == null || p.category == _selectedCategory;
      final matchesBrand =
          _selectedBrand == kBrands.first || p.brand == _selectedBrand;
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query);
      final matchesFavorite =
          !_showOnlyFavorites || _favoriteIds.contains(p.id);
      return matchesCategory && matchesBrand && matchesQuery && matchesFavorite;
    }).toList();
  }

  // Добавить в избранное
  void _toggleFavorite(String productId) {
    setState(() {
      if (!_favoriteIds.remove(productId)) {
        _favoriteIds.add(productId);
      }
    });
  }

  // Открыть экран товара
  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          isFavorite: _favoriteIds.contains(product.id),
          onFavoriteToggle: () => _toggleFavorite(product.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      // Верхняя панель
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 16,
        title: Row(
          children: [
            // Логотип
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.devices_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to TechHub 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Text(
                    'Find your next gadget',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Кнопка «Только избранное»
          IconButton(
            tooltip: 'Favorites only',
            onPressed: () =>
                setState(() => _showOnlyFavorites = !_showOnlyFavorites),
            icon: Icon(
              _showOnlyFavorites
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _showOnlyFavorites ? AppColors.sale : null,
            ),
          ),
          // Кнопка корзины
          const CartIconButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchField()),
          SliverToBoxAdapter(child: _buildBrandFilter()),
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          const SliverToBoxAdapter(child: _PromoBanner()),
          SliverToBoxAdapter(child: _buildSectionHeader(products.length)),
          if (products.isEmpty)
            // Ничего не найдено
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else
            // Сетка товаров
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: products.length,
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      isFavorite: _favoriteIds.contains(product.id),
                      onTap: () => _openDetails(product),
                      onFavoriteTap: () => _toggleFavorite(product.id),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Поиск
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Search iPhone, Galaxy, MacBook…',
          prefixIcon: Icon(Icons.search_rounded),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Фильтр по бренду
  Widget _buildBrandFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          segments: [
            for (final brand in kBrands)
              ButtonSegment(
                value: brand,
                label: Text(
                  brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          selected: {_selectedBrand},
          onSelectionChanged: (selection) =>
              setState(() => _selectedBrand = selection.first),
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.white,
            selectedBackgroundColor: AppColors.primary,
            selectedForegroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  // Категории
  Widget _buildCategoryTabs() {
    final options = <ProductCategory?>[null, ...ProductCategory.values];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = options[index];
          final isSelected = category == _selectedCategory;
          final color = isSelected ? Colors.white : AppColors.primary;

          return ChoiceChip(
            avatar: Icon(
              category?.icon ?? Icons.apps_rounded,
              size: 18,
              color: color,
            ),
            label: Text(category?.label ?? 'All'),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _selectedCategory = category),
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            side: BorderSide.none,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          );
        },
      ),
    );
  }

  // Заголовок раздела
  Widget _buildSectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _showOnlyFavorites ? 'Your favorites' : 'Popular now',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '$count items',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// Промо-баннер
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Week',
                      style: TextStyle(
                        color: Color(0xFF9DB0FF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Up to -10% on iPad & MacBook + 0% installment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Пустой результат
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'Nothing found',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
