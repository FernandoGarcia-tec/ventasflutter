import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/product.dart';
import 'dart:async'; // Import for Future
import '../widgets/image_carousel.dart';
import '../widgets/product_grid.dart';

// Define the colors based on the provided hex values
const Color accentColor = Color(0xFF4B0082);

class HomePageBody extends StatelessWidget {
  final Future<List<Product>> productsFuture; // Future to fetch products
  final List<Product> filteredProducts;
  final Function(List<Product>) onProductsFetched;

  const HomePageBody({
    Key? key,
    required this.productsFuture,
    required this.filteredProducts,
    required this.onProductsFetched,
  }) : super(key: key);

  @override
  // Added the build method
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Product>>(
            future: productsFuture,
            initialData: [], // Provide initial data
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => onProductsFetched(snapshot.data!),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No products found.'));
              } else {
                final products = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageCarousel(
                      // Display the image carousel
                      products: products,
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                      ),
                    ),
                    const Padding(
                      // Title for featured products
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8.0,
                      ), // Increased vertical padding
                      child: Text(
                        'Productos Destacados',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.black87, // Use a dark color for the title
                        ),
                      ),
                    ),
                    const Divider(
                      // Added a Divider
                      color: Colors.grey,
                      height: 1, // Adjusted height
                      thickness: 0.5, // Adjusted thickness
                      endIndent: 8.0,
                    ),
                    ProductGrid(
                      products: filteredProducts,
                    ), // Use filteredProducts here
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
