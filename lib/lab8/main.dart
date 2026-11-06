import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'screens/catalog_screen.dart';

void main() {
  runApp(const SmartCatalogApp());
}

class SmartCatalogApp extends StatelessWidget {
  const SmartCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Catalog',
      debugShowCheckedModeBanner: false,
      // В браузере и на ПК Flutter по умолчанию не даёт "тянуть" списки мышкой.
      // Разрешаем перетаскивание мышью, чтобы работал Pull-to-Refresh.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}
