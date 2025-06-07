import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final CartProvider cart;

  const ProductGrid({required this.products, required this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product, cart: cart);
        },
      ),
    );
  }
}
