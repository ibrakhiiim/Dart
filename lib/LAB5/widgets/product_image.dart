import 'package:flutter/material.dart';

// Картинка товара
class ProductImage extends StatelessWidget {
  final String url;
  final IconData fallbackIcon;
  final Color tint;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.url,
    this.fallbackIcon = Icons.devices_rounded,
    this.tint = const Color(0xFF3B5BFD),
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      // Пока грузится
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(icon: fallbackIcon, tint: tint, isLoading: true);
      },
      // Если не загрузилась
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(icon: fallbackIcon, tint: tint, isLoading: false),
    );
  }
}

// Заглушка
class _Placeholder extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final bool isLoading;

  const _Placeholder({
    required this.icon,
    required this.tint,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint.withValues(alpha: 0.30),
            tint.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : FractionallySizedBox(
                widthFactor: 0.4,
                heightFactor: 0.4,
                child: FittedBox(
                  child: Icon(icon, color: tint.withValues(alpha: 0.75)),
                ),
              ),
      ),
    );
  }
}
