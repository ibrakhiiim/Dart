import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/cart_controller.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TechMarketApp());
}

class TechMarketApp extends StatefulWidget {
  const TechMarketApp({super.key});

  @override
  State<TechMarketApp> createState() => _TechMarketAppState();
}

class _TechMarketAppState extends State<TechMarketApp> {
  final CartController _cart = CartController();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cart,
      child: MaterialApp(
        title: 'Tech Market',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3),
            ),
            child: child!,
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}