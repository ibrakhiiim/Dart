import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ProductExplorerApp());

class ProductExplorerApp extends StatelessWidget {
  const ProductExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Product Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ProductListScreen(),
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'] is Map<String, dynamic>
        ? json['rating'] as Map<String, dynamic>
        : <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Untitled product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? 'No description.',
      category: json['category'] as String? ?? 'other',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingJson['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingJson['count'] as num?)?.toInt() ?? 0,
    );
  }

  List<String> get gallery => [imageUrl, imageUrl, imageUrl];
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ProductApi {
  static const String _url = 'https://fakestoreapi.com/products';
  static const Duration _timeout = Duration(seconds: 5);

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_url)).timeout(_timeout);

    switch (response.statusCode) {
      case 200:
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      case 404:
        throw ApiException('Error 404: Products not found on the server.');
      case 500:
        throw ApiException('Error 500: Internal server error. Try again later.');
      default:
        throw ApiException('Unexpected server response: ${response.statusCode}');
    }
  }
}

enum LoadState { loading, success, error }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  LoadState _state = LoadState.loading;
  List<Product> _products = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({bool showSpinner = true}) async {
    if (showSpinner) setState(() => _state = LoadState.loading);

    try {
      final products = await ProductApi.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _state = LoadState.success;
      });
    } on SocketException {
      _handleError('No internet connection.\nTurn off Airplane mode or check Wi-Fi.', showSpinner);
    } on TimeoutException {
      _handleError('Connection timed out (10 seconds).\nThe server is not responding.', showSpinner);
    } on ApiException catch (e) {
      _handleError(e.message, showSpinner);
    } on http.ClientException {
      _handleError('Network error. Please check your connection.', showSpinner);
    } catch (e) {
      _handleError('Something went wrong:\n$e', showSpinner);
    }
  }

  void _handleError(String message, bool showSpinner) {
    if (!mounted) return;
    if (!showSpinner && _products.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.replaceAll('\n', ' '))),
      );
      return;
    }
    setState(() {
      _errorMessage = message;
      _state = LoadState.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Product Explorer'),
        centerTitle: true,
      ),
      body: switch (_state) {
        LoadState.loading => const Center(child: CircularProgressIndicator()),
        LoadState.error => ErrorView(message: _errorMessage, onRetry: _loadProducts),
        LoadState.success => RefreshIndicator(
          onRefresh: () => _loadProducts(showSpinner: false),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _products.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 88),
            itemBuilder: (context, index) => ProductTile(product: _products[index]),
          ),
        ),
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.shade500),
            const SizedBox(height: 16),
            const Text(
              'Oops! Connection problem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Hero(
        tag: 'product_image_${product.id}',
        child: Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ProductImage(url: product.imageUrl),
        ),
      ),
      title: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: RatingRow(rating: product.rating, reviewCount: product.reviewCount),
      ),
      trailing: Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
    );
  }
}

class RatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingRow({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1)),
        const SizedBox(width: 4),
        Text('($reviewCount reviews)', style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  final String url;

  const ProductImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (context, error, stackTrace) =>
      const Center(child: Icon(Icons.broken_image_outlined, color: Colors.grey)),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showShareSheet() {
    final deepLink = 'narxoz://store/product/${widget.product.id}';

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Share this product',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      deepLink,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: deepLink));
                if (!sheetContext.mounted) return;
                Navigator.pop(sheetContext);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied: $deepLink')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Link'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final gallery = product.gallery;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product #${product.id}'),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share),
            onPressed: _showShareSheet,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 320,
            color: Colors.white,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: gallery.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final image = Padding(
                      padding: const EdgeInsets.all(28),
                      child: ProductImage(url: gallery[index]),
                    );
                    return index == 0
                        ? Hero(tag: 'product_image_${product.id}', child: image)
                        : image;
                  },
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${gallery.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(gallery.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? colors.primary : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RatingRow(rating: product.rating, reviewCount: product.reviewCount),
                const SizedBox(height: 12),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${product.title}" added to cart')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(
                'Add to Cart  •  \$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}