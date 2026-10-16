import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/cart_controller.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TechHubApp());
}

class TechHubApp extends StatefulWidget {
  const TechHubApp({super.key});

  @override
  State<TechHubApp> createState() => _TechHubAppState();
}

class _TechHubAppState extends State<TechHubApp> {
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
        title: 'TechHub',
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