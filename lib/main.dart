import 'package:flutter/material.dart';
import 'presentation/screens/product_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ShopifyApp());
}

class ShopifyApp extends StatelessWidget {
  const ShopifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ProductListScreen(),
    );
  }
}