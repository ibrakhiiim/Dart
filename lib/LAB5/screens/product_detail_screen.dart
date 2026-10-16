import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/bookmark_badge.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/category_badge.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/color_option.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_stars.dart';
import '../widgets/spec_tile.dart';
import 'cart_screen.dart';

// Экран товара
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const double _wideBreakpoint = 720;
  static const int _installmentMonths = 24;

  late bool _isBookmarked;
  late ProductColor _selectedColor;
  StorageOption? _selectedStorage;
  int _quantity = 1;
  bool _isDescriptionExpanded = false;

  Product get _product => widget.product;

  int get _unitPrice => _product.priceFor(_selectedStorage);

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isFavorite;
    _selectedColor = _product.colors.first;
    _selectedStorage =
        _product.storageOptions.isEmpty ? null : _product.storageOptions.first;
  }

  // Закладка
  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    widget.onFavoriteToggle?.call();
  }

  // Выбор цвета
  void _selectColor(ProductColor color) {
    setState(() => _selectedColor = color);
  }

  // Выбор памяти
  void _selectStorage(StorageOption storage) {
    setState(() => _selectedStorage = storage);
  }

  // Кнопки плюс и минус
  void _increment() {
    if (_quantity < CartController.maxQuantityPerItem) {
      setState(() => _quantity++);
    }
  }

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  // Читать далее
  void _toggleDescription() {
    setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
  }

  // Открыть корзину
  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  // Добавить в корзину
  void _addToCart() {
    CartScope.read(context).add(
      product: _product,
      color: _selectedColor,
      storage: _selectedStorage,
      quantity: _quantity,
    );

    final variant = [
      _selectedColor.name,
      if (_selectedStorage != null) _selectedStorage!.label,
    ].join(', ');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          content: Text('Added $_quantity × ${_product.name} ($variant)'),
          action: SnackBarAction(
            label: 'VIEW CART',
            textColor: Colors.white,
            onPressed: _openCart,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Нижняя панель Add to Cart
      bottomNavigationBar: BottomActionBar(
        totalPrice: _unitPrice * _quantity,
        quantity: _quantity,
        onDecrement: _quantity > 1 ? _decrement : null,
        onIncrement:
            _quantity < CartController.maxQuantityPerItem ? _increment : null,
        onAddToCart: _addToCart,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _wideBreakpoint;
          return isWide
              ? _buildWideLayout()
              : _buildNarrowLayout(constraints);
        },
      ),
    );
  }

  // Телефон
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    final coverHeight = (constraints.maxWidth * 0.95).clamp(260.0, 440.0);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: coverHeight, child: _buildCover(rounded: false)),
          _buildDetails(),
        ],
      ),
    );
  }

  // Планшет
  Widget _buildWideLayout() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildCover(rounded: true)),
            const SizedBox(width: 24),
            Expanded(child: SingleChildScrollView(child: _buildDetails())),
          ],
        ),
      ),
    );
  }

  // Обложка (Stack)
  Widget _buildCover({required bool rounded}) {
    final cover = Stack(
      children: [
        // Картинка
        Positioned.fill(
          child: Hero(
            tag: 'product-${_product.id}',
            child: ProductImage(
              url: _product.imageUrl,
              fallbackIcon: _product.category.icon,
              tint: _selectedColor.color,
            ),
          ),
        ),
        // Затемнение сверху
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), Color(0x00000000)],
              ),
            ),
          ),
        ),
        // Верхние кнопки
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Кнопка «Назад»
                  if (Navigator.of(context).canPop())
                    CircleIconButton(
                      tooltip: 'Back',
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  const Spacer(),
                  // Кнопка корзины
                  _CartCircleButton(onTap: _openCart),
                  const SizedBox(width: 10),
                  // Кнопка закладки
                  BookmarkBadge(
                    isBookmarked: _isBookmarked,
                    onTap: _toggleBookmark,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Бейдж скидки
        if (_product.hasDiscount)
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.sale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${_product.discountPercent}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );

    if (!rounded) return cover;
    return ClipRRect(borderRadius: BorderRadius.circular(28), child: cover);
  }

  // Информация о товаре
  Widget _buildDetails() {
    final textTheme = Theme.of(context).textTheme;
    final oldPrice = _product.oldPriceFor(_selectedStorage);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Бренд и наличие
          Row(
            children: [
              Expanded(
                child: Text(
                  _product.brand.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.success),
              const SizedBox(width: 4),
              const Text(
                'In stock',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Название
          Text(
            _product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),

          // Рейтинг
          Row(
            children: [
              RatingStars(rating: _product.rating),
              const SizedBox(width: 8),
              Text(
                _product.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '(${_product.reviewCount} reviews)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Цена
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  formatPrice(_unitPrice),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (oldPrice != null) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    formatPrice(oldPrice),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Рассрочка
          Text(
            'or ${formatPrice((_unitPrice / _installmentMonths).ceil())}/mo '
            '× $_installmentMonths months, 0% installment',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Теги
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (index, tag) in _product.tags.indexed)
                CategoryBadge(label: tag, highlighted: index == 0),
            ],
          ),
          const SizedBox(height: 24),

          // Выбор цвета
          _SectionTitle(title: 'Color', trailing: _selectedColor.name),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final color in _product.colors)
                ColorOption(
                  option: color,
                  selected: color.name == _selectedColor.name,
                  onTap: () => _selectColor(color),
                ),
            ],
          ),

          // Выбор памяти
          if (_product.storageOptions.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SectionTitle(
              title: 'Storage',
              trailing: _selectedStorage?.label,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final storage in _product.storageOptions)
                  ChoiceChip(
                    label: Text(storage.label),
                    selected: storage.label == _selectedStorage?.label,
                    onSelected: (_) => _selectStorage(storage),
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: storage.label == _selectedStorage?.label
                          ? Colors.white
                          : AppColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Характеристики
          const _SectionTitle(title: 'Specifications'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final tileWidth = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final spec in _product.specs)
                    SpecTile(spec: spec, width: tileWidth),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Описание
          const _SectionTitle(title: 'Description'),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Text(
              _product.description,
              maxLines: _isDescriptionExpanded ? null : 3,
              overflow: _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Кнопка «Read more»
          TextButton(
            onPressed: _toggleDescription,
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(_isDescriptionExpanded ? 'Show less' : 'Read more'),
          ),
        ],
      ),
    );
  }
}

// Заголовок секции
class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 12),
        if (trailing != null)
          Expanded(
            child: Text(
              trailing!,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

// Кнопка корзины с бейджем
class _CartCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CartCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).totalCount;
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      backgroundColor: AppColors.sale,
      offset: const Offset(-2, 2),
      child: CircleIconButton(
        tooltip: 'Cart',
        icon: Icons.shopping_bag_outlined,
        onTap: onTap,
      ),
    );
  }
}
