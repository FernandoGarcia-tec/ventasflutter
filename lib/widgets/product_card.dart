import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'image_loader.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final CartProvider cart;

  const ProductCard({required this.product, required this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        children: [
          Expanded(flex: 3, child: ImageLoader(imageUrl: product.imageUrl)),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text('\$${product.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () => cart.add(product),
                      child: const Text(
                        'Agregar',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(60, 30),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
