import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_item.dart'; // Import the ProductItem widget

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      shrinkWrap: true, // Allow the grid to take only the necessary space
      physics:
          const NeverScrollableScrollPhysics(), // Disable the grid's own scrolling
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Set crossAxisCount to 2
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.50, // Make items even taller
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(product: product); // Use the ProductItem widget
      },
    );
  }
}
