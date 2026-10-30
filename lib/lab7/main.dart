import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

class Product {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final String date;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.date,
  });
}

const List<Product> products = [
  Product(
    id: 1,
    title: 'iPhone 16 Pro',
    description:
    'Apple smartphone with a 6.3-inch display and A18 Pro chip. '
        'Titanium design, triple camera system and a dedicated Camera Control button.',
    imageUrl: 'https://picsum.photos/id/160/600/400',
    price: 999.00,
    category: 'Smartphones',
    date: '21 Aug 2023',
  ),
  Product(
    id: 2,
    title: 'Samsung Galaxy S24 Ultra',
    description:
    'Large 6.8-inch display, built-in S Pen and a 200 MP main camera. '
        'Great for productivity and mobile photography.',
    imageUrl: 'https://picsum.photos/id/1/600/400',
    price: 1199.00,
    category: 'Smartphones',
    date: '03 Mar 2020',
  ),
  Product(
    id: 3,
    title: 'MacBook Air M3',
    description:
    'Thin and light laptop with Apple M3 chip, 13.6-inch Liquid Retina '
        'display and all-day battery life.',
    imageUrl: 'https://picsum.photos/id/0/600/400',
    price: 1099.00,
    category: 'Laptops',
    date: '09 Nov 2021',
  ),
  Product(
    id: 4,
    title: 'Sony WH-1000XM5',
    description:
    'Wireless noise-cancelling headphones with up to 30 hours of battery '
        'life and a comfortable lightweight design.',
    imageUrl: 'https://picsum.photos/id/180/600/400',
    price: 399.00,
    category: 'Headphones',
    date: '14 Jun 2025',
  ),
];

class FavoritesController extends ChangeNotifier {
  final Set<int> _ids = {};

  bool isFavorite(Product p) => _ids.contains(p.id);

  List<Product> get items =>
      products.where((p) => _ids.contains(p.id)).toList();

  void toggle(Product p) {
    _ids.contains(p.id) ? _ids.remove(p.id) : _ids.add(p.id);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          title: 'Lab 7 Navigation',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: const RootScreen(),
        );
      },
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  final FavoritesController _favorites = FavoritesController();

  static const _titles = ['Feed', 'Favorites', 'Profile'];

  @override
  void dispose() {
    _favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          FeedTab(favorites: _favorites),
          FavoritesTab(favorites: _favorites),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedTab extends StatelessWidget {
  final FavoritesController favorites;
  const FeedTab({super.key, required this.favorites});

  Future<void> _openDetail(BuildContext context, Product product) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(favorites: favorites),
        settings: RouteSettings(arguments: product),
      ),
    );

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return ProductCard(
            product: p,
            isFavorite: favorites.isFavorite(p),
            onTap: () => _openDetail(context, p),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: NetImage(url: product.imageUrl, width: 110, height: 100),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(product.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.chevron_right,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  final FavoritesController favorites;
  const FavoritesTab({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) {
        final items = favorites.items;
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('No favorites yet.\nOpen an item and tap ❤ to save it.',
                    textAlign: TextAlign.center),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final p = items[i];
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: NetImage(url: p.imageUrl, width: 56, height: 56),
                ),
                title: Text(p.title),
                subtitle:
                Text('${p.category} • \$${p.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => favorites.toggle(p),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text('Student Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Center(
          child: Text('student@university.kz',
              style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Notifications'),
          secondary: const Icon(Icons.notifications),
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        SwitchListTile(
          title: const Text('Dark mode'),
          secondary: const Icon(Icons.dark_mode),
          value: isDarkMode.value,
          onChanged: (v) => setState(() => isDarkMode.value = v),
        ),
        const ListTile(
          leading: Icon(Icons.language),
          title: Text('Language'),
          trailing: Text('English'),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('App version'),
          trailing: Text('1.0.0'),
        ),
      ],
    );
  }
}

class DetailScreen extends StatelessWidget {
  final FavoritesController favorites;
  const DetailScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product.title),
        actions: [
          ListenableBuilder(
            listenable: favorites,
            builder: (context, _) {
              final fav = favorites.isFavorite(product);
              return IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? Colors.red : null),
                onPressed: () => favorites.toggle(product),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: NetImage(
                url: product.imageUrl, width: double.infinity, height: 250),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text(product.category)),
                    const SizedBox(width: 8),
                    Text(product.date,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 16),
                const Text('Description',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(product.description,
                    style: const TextStyle(fontSize: 15, height: 1.4)),
                const SizedBox(height: 24),
                ListenableBuilder(
                  listenable: favorites,
                  builder: (context, _) {
                    final fav = favorites.isFavorite(product);
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(
                            fav ? Icons.favorite : Icons.favorite_border),
                        label: Text(fav
                            ? 'Remove from favorites'
                            : 'Add to favorites'),
                        onPressed: () => favorites.toggle(product),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Feed'),
                    onPressed: () => Navigator.pop(
                      context,
                      'Returned from "${product.title}"',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NetImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const NetImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }
}
